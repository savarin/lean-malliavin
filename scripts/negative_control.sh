#!/bin/bash
# Negative control: confirm the comparator rejects a mutated theorem statement.
#
# Mutates mderiv_closable's conclusion from `η = 0` to `η = η` (proved by rfl).
# Temporarily overwrites Solution.lean for the mutated build, then restores it.
# Requires a passing baseline first.
set -euo pipefail
cd "$(dirname "$0")/.."

: "${COMPARATOR:?Set COMPARATOR to the comparator binary path}"
: "${LEAN4EXPORT:?Set LEAN4EXPORT to a v4.33.0-compatible lean4export binary}"

if [[ -n "${FAKE_LANDRUN:-}" ]]; then
  export COMPARATOR_LANDRUN="$FAKE_LANDRUN"
fi

echo "=== Negative control ==="

# Step 1: Verify baseline passes
echo "[1/3] Verifying baseline ..."
BASELINE=$(COMPARATOR_LEAN4EXPORT="$LEAN4EXPORT" lake env "$COMPARATOR" comparator.json 2>&1 || true)
if ! echo "$BASELINE" | grep -qi "Your solution is okay"; then
  echo "FAIL: baseline comparator run does not pass — negative control is unreliable"
  echo "$BASELINE" | tail -5
  exit 1
fi
echo "  Baseline passes"

# Step 2: Build a mutated Solution in a temp directory
echo "[2/3] Building mutated Solution ..."
WORKDIR=$(mktemp -d "${TMPDIR:-/tmp}/neg-ctrl-XXXXXX")

# Save original before any mutation
cp Solution.lean "$WORKDIR/Solution.lean.orig"
trap 'cp "$WORKDIR/Solution.lean.orig" Solution.lean; rm -rf "$WORKDIR"' EXIT

# Mutate: change mderiv_closable conclusion from `η = 0` to `η = η`
# and replace the proof term with `rfl`
sed 's/η = 0 :=/η = η :=/' Solution.lean \
  | sed 's/Malliavin\.mderiv_closable μ/rfl/' \
  | sed '/fun k ↦ ⟨(F k)\.1, Malliavin\.IsSmoothBounded\.mk/,/hF hD/d' \
  > "$WORKDIR/Solution.lean"

cp "$WORKDIR/Solution.lean" Solution.lean

echo "  Mutated: changed mderiv_closable conclusion from η = 0 to η = η"
if ! lake build Solution 2>&1 | tail -3; then
  echo "  (mutated build failed — trap restores Solution.lean)"
  exit 1
fi

# Step 3: Run comparator on mutated Solution
echo "[3/3] Running comparator on mutated Solution ..."
OUTPUT=$(COMPARATOR_LEAN4EXPORT="$LEAN4EXPORT" lake env "$COMPARATOR" comparator.json 2>&1 || true)
echo "$OUTPUT" | tail -5

# Trap restores Solution.lean on exit; rebuild to reset .lake cache
echo "  Restoring original and rebuilding ..."

if echo "$OUTPUT" | grep -qi "theorem statement.*do not match\|do not match\|statements.*differ\|typeAlphaEq.*false"; then
  echo "PASS: comparator correctly rejected the mutated Solution (statement mismatch)"
  exit 0
else
  echo "FAIL: comparator did not reject with a statement-mismatch error"
  exit 1
fi

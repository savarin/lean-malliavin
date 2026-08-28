#!/bin/bash
# Negative control: mutate the Solution statement and confirm the comparator
# rejects it. This proves the comparator is checking structural equality,
# not just that the file compiles.
set -euo pipefail
cd "$(dirname "$0")/.."

: "${COMPARATOR:?Set COMPARATOR to the comparator binary path}"
: "${LEAN4EXPORT:?Set LEAN4EXPORT to a v4.33.0-compatible lean4export binary}"

echo "=== Negative control ==="

# Back up the real Solution
cp Solution.lean Solution.lean.bak
trap 'mv Solution.lean.bak Solution.lean; rm -rf .lake/build/lib/lean/Solution.* .lake/build/ir/Solution.*' EXIT

# Write a mutated Solution that proves a different (trivially true) statement
cat > Solution.lean << 'LEAN'
import Malliavin

open Malliavin CameronMartin MeasureTheory ProbabilityTheory Filter Topology in
theorem mderiv_closable {W : Type*} [NormedAddCommGroup W] [NormedSpace ℝ W]
    [CompleteSpace W] [MeasurableSpace W] [BorelSpace W]
    [SecondCountableTopology W]
    (μ : Measure W) [IsGaussian μ]
    (F : ℕ → {F : W → ℝ // IsSmoothBounded F}) {η : Lp (Space μ) 2 μ}
    (hF : Filter.Tendsto (fun k ↦ (F k).2.toLp μ) Filter.atTop (𝓝 0))
    (hD : Filter.Tendsto (fun k ↦ (F k).2.mderivLp μ) Filter.atTop (𝓝 η)) :
    η = η := rfl
LEAN

echo "Mutated Solution: changed conclusion from 'η = 0' to 'η = η'"

# Build the mutated Solution
echo "Building mutated Solution..."
lake build Solution 2>&1 | tail -5

# Run comparator — expect failure
echo "Running comparator on mutated Solution..."
if [[ -n "${FAKE_LANDRUN:-}" ]]; then
  export COMPARATOR_LANDRUN="$FAKE_LANDRUN"
fi

if COMPARATOR_LEAN4EXPORT="$LEAN4EXPORT" lake env "$COMPARATOR" comparator.json 2>&1; then
  echo "FAIL: comparator accepted the mutated Solution (should have rejected)"
  exit 1
else
  echo "PASS: comparator correctly rejected the mutated Solution"
  exit 0
fi

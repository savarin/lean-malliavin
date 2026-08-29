#!/bin/bash
# Negative control: confirm the comparator rejects a mutated theorem statement.
#
# Requires a passing baseline first — if the unmutated comparator run fails,
# this test is unreliable (the mismatch message may come from the baseline
# failure, not from our mutation).
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

# Step 2: Build a mutated Solution in a temp file, swap it in, run comparator
echo "[2/3] Building mutated Solution ..."
MUTATED=$(mktemp "${TMPDIR:-/tmp}/SolutionXXXXXX")
trap 'rm -f "$MUTATED"; rm -rf .lake/build/lib/lean/Solution.* .lake/build/ir/Solution.*' EXIT

cat > "$MUTATED" << 'LEAN'
import Malliavin

open MeasureTheory ProbabilityTheory Filter Topology

noncomputable def CameronMartin.Space
    {W : Type*} [NormedAddCommGroup W] [NormedSpace ℝ W]
    [CompleteSpace W] [MeasurableSpace W] [BorelSpace W]
    [SecondCountableTopology W]
    (μ : Measure W) [IsGaussian μ] :
    Submodule ℝ (Lp ℝ 2 μ) :=
  Malliavin.CameronMartin.firstChaos μ

structure IsSmoothBounded {W : Type*} [NormedAddCommGroup W] [NormedSpace ℝ W]
    (F : W → ℝ) : Prop where
  contDiff : ContDiff ℝ 1 F
  bounded : ∃ C, ∀ x, |F x| ≤ C
  bounded_fderiv : ∃ C, ∀ x, ‖fderiv ℝ F x‖ ≤ C

noncomputable def IsSmoothBounded.toLp
    {W : Type*} [NormedAddCommGroup W] [NormedSpace ℝ W]
    [CompleteSpace W] [MeasurableSpace W] [BorelSpace W]
    [SecondCountableTopology W]
    {F : W → ℝ} (μ : Measure W) [IsGaussian μ]
    (hF : IsSmoothBounded F) :
    Lp ℝ 2 μ :=
  (Malliavin.IsSmoothBounded.mk
    hF.contDiff hF.bounded hF.bounded_fderiv).toLp μ

noncomputable def IsSmoothBounded.mderivLp
    {W : Type*} [NormedAddCommGroup W] [NormedSpace ℝ W]
    [CompleteSpace W] [MeasurableSpace W] [BorelSpace W]
    [SecondCountableTopology W]
    {F : W → ℝ} (μ : Measure W) [IsGaussian μ]
    (hF : IsSmoothBounded F) :
    Lp (CameronMartin.Space μ) 2 μ :=
  (Malliavin.IsSmoothBounded.mk
    hF.contDiff hF.bounded hF.bounded_fderiv).mderivLp μ

-- MUTATED: conclusion is η = η (trivially true) instead of η = 0
theorem mderiv_closable
    {W : Type*} [NormedAddCommGroup W] [NormedSpace ℝ W]
    [CompleteSpace W] [MeasurableSpace W] [BorelSpace W]
    [SecondCountableTopology W]
    (μ : Measure W) [IsGaussian μ]
    (F : ℕ → {F : W → ℝ // IsSmoothBounded F})
    {η : Lp (CameronMartin.Space μ) 2 μ}
    (hF : Tendsto (fun k ↦ (F k).2.toLp μ) atTop (𝓝 0))
    (hD : Tendsto (fun k ↦ (F k).2.mderivLp μ) atTop (𝓝 η)) :
    η = η := rfl
LEAN

# Swap in the mutated Solution, build, then restore via git checkout
trap 'git checkout -- Solution.lean; rm -f "$MUTATED"; rm -rf .lake/build/lib/lean/Solution.* .lake/build/ir/Solution.*' EXIT
cp "$MUTATED" Solution.lean

echo "  Mutated: changed conclusion from 'η = 0' to 'η = η'"
lake build Solution 2>&1 | tail -3

# Step 3: Run comparator on mutated Solution
echo "[3/3] Running comparator on mutated Solution ..."
OUTPUT=$(COMPARATOR_LEAN4EXPORT="$LEAN4EXPORT" lake env "$COMPARATOR" comparator.json 2>&1 || true)
echo "$OUTPUT" | tail -5

if echo "$OUTPUT" | grep -qi "theorem statement.*do not match\|do not match\|statements.*differ\|typeAlphaEq.*false"; then
  echo "PASS: comparator correctly rejected the mutated Solution (statement mismatch)"
  exit 0
else
  echo "FAIL: comparator did not reject with a statement-mismatch error"
  exit 1
fi

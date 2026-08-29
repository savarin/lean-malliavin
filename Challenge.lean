/-
Copyright (c) 2026 Ezzeri Esa. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.MeasureTheory.Function.ConvergenceInDistribution
import Mathlib.MeasureTheory.Function.Holder
import Mathlib.MeasureTheory.Measure.LevyConvergence
import Mathlib.MeasureTheory.Measure.LogLikelihoodRatio
import Mathlib.Probability.Distributions.Gaussian.Fernique
import Mathlib.Probability.Distributions.Gaussian.HasGaussianLaw.Basic
import Mathlib.Probability.Moments.CovarianceBilinDual

/-!
# Closability of the Malliavin derivative (Challenge)

This module states the closability theorem for the Malliavin derivative on an
abstract Gaussian Banach space. The definitions needed to state the theorem are
given sorry-bodied stubs here; their implementations live in the proof library
imported by `Solution.lean`.

## Main result

`mderiv_closable`: if smooth bounded functionals converge to zero in L² and
their Malliavin derivatives converge in L²(H), the limit derivative is zero.
-/

open MeasureTheory ProbabilityTheory Filter Topology
open scoped ENNReal NNReal Real Topology

/-- The Cameron–Martin Hilbert space: the closed first-chaos subspace of
centered continuous linear functionals in L²(μ). Filled by
`Malliavin.CameronMartin.firstChaos` in Solution.lean. -/
noncomputable def CameronMartin.Space
    {W : Type*} [NormedAddCommGroup W] [NormedSpace ℝ W]
    [CompleteSpace W] [MeasurableSpace W] [BorelSpace W]
    [SecondCountableTopology W]
    (μ : Measure W) [IsGaussian μ] :
    Submodule ℝ (Lp ℝ 2 μ) := sorry

/-- A bounded C¹ Fréchet functional with uniformly bounded derivative. -/
structure IsSmoothBounded {W : Type*} [NormedAddCommGroup W] [NormedSpace ℝ W]
    (F : W → ℝ) : Prop where
  contDiff : ContDiff ℝ 1 F
  bounded : ∃ C, ∀ x, |F x| ≤ C
  bounded_fderiv : ∃ C, ∀ x, ‖fderiv ℝ F x‖ ≤ C

/-- The L²(μ) equivalence class of a smooth bounded functional.
Filled by `Malliavin.IsSmoothBounded.toLp` in Solution.lean. -/
noncomputable def IsSmoothBounded.toLp
    {W : Type*} [NormedAddCommGroup W] [NormedSpace ℝ W]
    [CompleteSpace W] [MeasurableSpace W] [BorelSpace W]
    [SecondCountableTopology W]
    {F : W → ℝ} (μ : Measure W) [IsGaussian μ]
    (hF : IsSmoothBounded F) :
    Lp ℝ 2 μ := sorry

/-- The Malliavin derivative of a smooth bounded functional as an element
of L²(μ; H), where H is the Cameron–Martin space.
Filled by `Malliavin.IsSmoothBounded.mderivLp` in Solution.lean. -/
noncomputable def IsSmoothBounded.mderivLp
    {W : Type*} [NormedAddCommGroup W] [NormedSpace ℝ W]
    [CompleteSpace W] [MeasurableSpace W] [BorelSpace W]
    [SecondCountableTopology W]
    {F : W → ℝ} (μ : Measure W) [IsGaussian μ]
    (hF : IsSmoothBounded F) :
    Lp (CameronMartin.Space μ) 2 μ := sorry

theorem mderiv_closable
    {W : Type*} [NormedAddCommGroup W] [NormedSpace ℝ W]
    [CompleteSpace W] [MeasurableSpace W] [BorelSpace W]
    [SecondCountableTopology W]
    (μ : Measure W) [IsGaussian μ]
    (F : ℕ → {F : W → ℝ // IsSmoothBounded F})
    {η : Lp (CameronMartin.Space μ) 2 μ}
    (hF : Tendsto (fun k ↦ (F k).2.toLp μ) atTop (𝓝 0))
    (hD : Tendsto (fun k ↦ (F k).2.mderivLp μ) atTop (𝓝 η)) :
    η = 0 := sorry

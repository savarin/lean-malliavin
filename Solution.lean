/-
Copyright (c) 2026 Ezzeri Esa. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
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

theorem mderiv_closable
    {W : Type*} [NormedAddCommGroup W] [NormedSpace ℝ W]
    [CompleteSpace W] [MeasurableSpace W] [BorelSpace W]
    [SecondCountableTopology W]
    (μ : Measure W) [IsGaussian μ]
    (F : ℕ → {F : W → ℝ // IsSmoothBounded F})
    {η : Lp (CameronMartin.Space μ) 2 μ}
    (hF : Tendsto (fun k ↦ (F k).2.toLp μ) atTop (𝓝 0))
    (hD : Tendsto (fun k ↦ (F k).2.mderivLp μ) atTop (𝓝 η)) :
    η = 0 :=
  Malliavin.mderiv_closable μ
    (fun k ↦ ⟨(F k).1, Malliavin.IsSmoothBounded.mk
      (F k).2.contDiff (F k).2.bounded (F k).2.bounded_fderiv⟩)
    hF hD

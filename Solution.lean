import Malliavin

open Malliavin CameronMartin MeasureTheory ProbabilityTheory Filter Topology in
theorem mderiv_closable {W : Type*} [NormedAddCommGroup W] [NormedSpace ℝ W]
    [CompleteSpace W] [MeasurableSpace W] [BorelSpace W]
    [SecondCountableTopology W]
    (μ : Measure W) [IsGaussian μ]
    (F : ℕ → {F : W → ℝ // IsSmoothBounded F}) {η : Lp (Space μ) 2 μ}
    (hF : Filter.Tendsto (fun k ↦ (F k).2.toLp μ) Filter.atTop (𝓝 0))
    (hD : Filter.Tendsto (fun k ↦ (F k).2.mderivLp μ) Filter.atTop (𝓝 η)) :
    η = 0 := Malliavin.mderiv_closable μ F hF hD

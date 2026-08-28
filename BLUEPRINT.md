# Blueprint

Plain-mathematics proof route for `Challenge.lean`, traced from the three
source files (`Malliavin/CameronMartin.lean`, `CameronMartinTheorem.lean`,
`MalliavinDerivative.lean`). No Lean code below — declaration names are
cited only as pointers back to the source.

## Target

One theorem: `mderiv_closable` (closability of the Malliavin derivative).

If `Fₖ` are smooth bounded functionals with `Fₖ → 0` in `L²(μ)` and
`DFₖ → η` in `L²(μ; H)`, then `η = 0`. This establishes that the
Malliavin derivative has a well-defined closed extension whose domain is
the Sobolev space `𝔻₁,₂`.

## Proof architecture

The proof spans three layers, each a source file.

**Layer 0 — Mathlib primitives.** Gaussian measures (`IsGaussian`), `Lᵖ`
spaces, continuous linear maps, Fréchet derivatives, inner product spaces,
and the Riesz representation theorem. Nothing here is proved by us.

**Layer 1 — the Cameron–Martin space** (`CameronMartin.lean`, 416 lines).
`firstChaos`/`Space` is the closed linear span, inside `L²(μ)`, of every
centered continuous linear functional on `W`. This is the Hilbert space the
Malliavin derivative takes values in. The covariance embedding `inclusion`
maps it continuously and injectively into the ambient Banach space `W`.

**Layer 2 — the Cameron–Martin theorem** (`CameronMartinTheorem.lean`,
917 lines). Quasi-invariance of Gaussian measures under Cameron–Martin
translations: the law of `x + h` is absolutely continuous with respect to
`μ` when `h` lies in the Cameron–Martin space, with an explicit
Radon–Nikodym derivative (the exponential martingale). The key output for
Layer 3 is the Gaussian integration by parts formula:
`∫ ⟪DF, h⟫ dμ = ∫ F · h dμ`, which gives the Malliavin derivative a
formal adjoint.

**Layer 3 — the Malliavin derivative and closability**
(`MalliavinDerivative.lean`, 1510 lines). For a smooth bounded functional
`F`, the Malliavin derivative at `x` is the Cameron–Martin vector
representing `h ↦ fderiv ℝ F x (inclusion μ h)` via Riesz. The structure
`IsSmoothBounded` collects `C¹` regularity with uniform bounds on `F` and
its derivative. The closability proof proceeds by:

1. **Adjoint relation.** From the integration by parts formula (Layer 2),
   for any smooth bounded `G` and Cameron–Martin direction `h`:
   `⟪mderivLp G, h⟫ = ⟪toLp G, δ(h)⟫` where `δ(h)` is the divergence.
   The `simpleVec`/`simpleDiv` families (tensor products of smooth
   functionals with Cameron–Martin vectors) form a total family in
   `L²(μ; H)`.

2. **Abstract closability lemma** (`eq_zero_of_tendsto_of_adjoint`). If a
   linear operator `T` has a family of adjoint test vectors `{eₖ}` that is
   total in the codomain, and `Fₙ → 0` with `TFₙ → η`, then
   `⟪η, eₖ⟫ = lim ⟪TFₙ, eₖ⟫ = lim ⟪Fₙ, T*eₖ⟫ = 0` for every `k`, so
   `η = 0` by totality.

3. **Application.** `mderiv_closable` instantiates this with `T = mderivLp`,
   the simple vectors as the total family, and the adjoint relation from
   step 1.

## No definition holes

Unlike the full Clark–Ocone submission, `mderiv_closable` requires no
`definition_names` in `comparator.json`. Both Challenge and Solution import
the same Malliavin library, so all types elaborate identically. The
comparator checks structural equality of the single theorem and its
transitive dependencies without any bypasses.

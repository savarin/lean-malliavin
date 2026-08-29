# Blueprint

Plain-mathematics proof route for `Challenge.lean`, traced from the three
source files (`Malliavin/CameronMartin.lean`, `CameronMartinTheorem.lean`,
`MalliavinDerivative.lean`). No Lean code below — declaration names are
cited only as pointers back to the source.

## Target

Two theorems:

1. `integral_inner_mderiv` — Gaussian integration by parts.
2. `mderiv_closable` — closability of the Malliavin derivative.

Together these form a coherent foundational Malliavin-calculus result: the
integration-by-parts formula supplies the adjoint relation, and the adjoint
relation yields closability.

## Explicit boundary

Challenge.lean constructs all statement-level mathematics directly from
Mathlib:

- the Cameron–Martin space as a closed first-chaos submodule;
- the centered identity in L²;
- the covariance map and Cameron–Martin inclusion;
- completeness of the Cameron–Martin space;
- the Riesz-represented Malliavin derivative;
- `IsSmoothBounded` (bounded C¹ core);
- integrability results (`memLp`, `memLp_mderiv`);
- `IsSmoothBounded.toLp` and `IsSmoothBounded.mderivLp`.

There are no definition holes. Solution.lean repeats the same declarations
and imports the extracted `Malliavin` proof library. The repeated objects are
definitionally equal to the library objects, so the two completed library
theorems close the Solution goals without bridging definitions.

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
its derivative.

The **integration by parts** proof (`integral_inner_mderiv`) uses the
adjoint identity from Layer 2 directly: for any smooth bounded `G` and
Cameron–Martin direction `h`, the Malliavin inner product equals pairing
against the first-chaos representative.

The **closability** proof (`mderiv_closable`) proceeds by:

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

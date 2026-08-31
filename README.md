# lean-malliavin

The Clark--Ocone representation theorem for Brownian functionals
on an abstract Gaussian Banach space, formalized in Lean 4 against
Mathlib. Prepared for submission to
[Palomar](https://palomar-registry.org).

## Main results

For a pre-Brownian process on a Gaussian Banach space whose coordinates
generate the measurable space:

- `generated_clark_ocone`: there exist a time realization of the closed
  Malliavin derivative and a Brownian Itô isometry such that every
  terminal L² variable has a stochastic-integral representation and the
  predictable projection of the derivative recovers the conditional
  expectations in the textbook Clark--Ocone identity.

## Scope

The Clark--Ocone formula is the central representation theorem of
Malliavin calculus. It says that any square-integrable functional of
Brownian motion can be written as its expectation plus a stochastic
integral of the conditional expectation of its Malliavin derivative —
recovering a random variable from the rate at which it changes along
Cameron--Martin directions. This connects the derivative calculus
(closability, Sobolev spaces) to the integral calculus (Itô isometry,
martingale representation) and is the gateway to hedging formulas,
density estimates, and anticipating stochastic calculus.

The formalization works on a separable Banach space carrying a
Gaussian measure whose coordinate functionals generate the measurable
space — a hypothesis textbooks usually hide by fixing the canonical
Wiener space. The proof constructs an abstract Hilbert-space contract
(isometric integration, surjectivity, duality identity) and obtains
the formula by Riesz uniqueness; all analytic difficulty lives in
building one instance of this contract on the natural Brownian
filtration, through the Wiener chaos decomposition, Itô isometry,
and martingale representation. The audience is researchers in
stochastic analysis and the formalization community working on
probability theory in Lean/Mathlib.

The theorem operates on the natural (generated, non-augmented)
filtration — textbooks state Clark--Ocone under the usual conditions
on an arbitrary filtration. `IsPreBrownianReal` defines Brownian
motion at the law level (correct finite-dimensional distributions,
no path continuity assumed). The Sobolev space D^{1,2} is realized
as the closure of the bounded-C¹ graph.

For a detailed proof route in plain mathematics, see
`BLUEPRINT.md`.

## Trust boundary

- `ClarkOconeChallenge.lean` (312 lines) imports only Mathlib.
  Every definition needed by the theorem statement is given
  explicitly — zero definition holes. Only the single advertised
  theorem proof is omitted.
- `ClarkOconeSolution.lean` imports the completed proof development.
- `comparator-clark-ocone.json` lists one theorem
  (`PalomarClarkOcone.generated_clark_ocone`) and no definition holes.
- The proved declaration uses only `propext`, `Quot.sound`, and
  `Classical.choice`.

## Proof architecture

```text
Gaussian measure P on Banach space W
     │
     ├── Cameron–Martin space H (first chaos)
     │         │
     │         └── covariance embedding H → W
     │
     ├── Malliavin derivative DF (Fréchet along H)
     │         │
     │         ├── integration by parts
     │         └── closability (graph closure)
     │
     ├── Wiener chaos decomposition
     │         │
     │         ├── Hermite polynomials
     │         ├── multiple stochastic integrals
     │         └── chaos–martingale representation
     │
     └── Brownian realization
               │
               ├── time derivative (H-valued → process)
               ├── Itô isometry (isometric extension)
               ├── elementary integration (indicator × adapted)
               ├── martingale representation
               │         │
               │         └── every L² variable = E[·] + ∫
               │
               └── Clark–Ocone on closed graph
                         │
                         └── F = E[F] + ∫ E[D_t F | F_t] dB_t
```

The proof library (`Malliavin/`) contains 52 files. The dependency chain
runs: `CameronMartin` → `MalliavinDerivative` → `WienerChaos` →
`BrownianClarkOconeCapstone`.

## Build and verify

Lean and Mathlib 4.33.0 are pinned.

```bash
lake exe cache get
lake build
python3 scripts/check_boundary.py
```

For a local Comparator smoke test:

```bash
export COMPARATOR=/path/to/comparator
export LEAN4EXPORT=/path/to/lean4export
export FAKE_LANDRUN=/path/to/fake-landrun.sh  # macOS only
scripts/run_comparator.sh
```

A negative control script deliberately weakens the theorem and verifies
that Comparator rejects the mutation:

```bash
scripts/negative_control.sh
```

Palomar runs its own pinned Comparator, Landrun sandbox, and
NanoDa kernel.

## Historical submission

The initial Palomar registration (PALOMAR-2026-08-29-000016) used
`Challenge.lean` and `Solution.lean`, which submit two foundational
results: `integral_inner_mderiv` (Gaussian integration by parts) and
`mderiv_closable` (closability of the Malliavin derivative). These files
remain in the repo as the historical submission boundary. The
Clark--Ocone capstone subsumes both results.

## License

Apache-2.0.

# lean-malliavin

Gaussian integration by parts and closability of the Malliavin derivative on
an abstract Gaussian Banach space, formalized in Lean 4 against Mathlib.
Prepared for submission to [Palomar](https://palomar-registry.org).

## The theorems

Two results form the Malliavin core:

**Gaussian integration by parts** (`integral_inner_mderiv`). For a smooth
bounded functional `F` and Cameron–Martin vector `h`:
`∫ ⟪DF, h⟫ dμ = ∫ F · h dμ`. This identity exposes the formal adjoint
relation that drives the closability proof.

**Closability** (`mderiv_closable`). If smooth bounded functionals converge
to zero in L² and their Malliavin derivatives converge in L²(H), the limit
derivative is zero. This is the foundational estimate that makes the
Malliavin derivative a closable operator, enabling its extension from smooth
test functionals to the Sobolev space D^{1,2}.

Both results adapt Chapter 1, §1.2 of Nualart's *The Malliavin Calculus and
Related Topics* (2nd ed., Springer,
[doi:10.1007/3-540-28329-3](https://doi.org/10.1007/3-540-28329-3)) to an
abstract Gaussian Banach space with a bounded-C¹ core.

## Trust boundary

- **Challenge.lean** (217 lines) imports only Mathlib. Every definition
  needed by the theorem statements is given explicitly from Mathlib — there
  are zero definition holes. Only the two advertised theorem proofs are
  omitted (`sorry`).
- **Solution.lean** repeats the same declaration block and imports the full
  `Malliavin` proof library. The repeated objects are definitionally equal
  to the library objects, so the two completed library theorems close the
  Solution goals.
- **comparator.json** lists two theorems and no definition holes.

A mathematical reader can audit both statements by reading Challenge.lean
alone (217 lines, Mathlib-only imports).

## Provenance

The proof library (`Malliavin/`) is extracted from
[lean-clark-ocone](https://github.com/savarin/lean-clark-ocone) at commit
`41d3f1509bc8f5c58ff3f17a4d9121ef4c3bb8a4`. Three files (CameronMartin,
CameronMartinTheorem, MalliavinDerivative) form the dependency chain for
both results.

## Build and verify

Requires Lean 4.33.0 and a Mathlib cache.

```bash
lake exe cache get
lake build Challenge Solution
```

### Smoke check (elaboration + axiom audit)

```bash
python3 scripts/check_boundary.py
```

### Comparator (requires lean4export and comparator binaries)

```bash
export COMPARATOR=/path/to/comparator
export LEAN4EXPORT=/path/to/lean4export
scripts/run_comparator.sh
```

Local comparator runs use Lean's default kernel, not NanoDa. Palomar injects
its own protected NanoDa configuration at submission time.

### Negative control

```bash
export COMPARATOR=/path/to/comparator
export LEAN4EXPORT=/path/to/lean4export
scripts/negative_control.sh
```

## Axioms

`propext`, `Classical.choice`, `Quot.sound` — the standard Lean 4 axioms.

## License

Apache-2.0

# lean-malliavin

Closability of the Malliavin derivative on an abstract Gaussian Banach space,
formalized in Lean 4 against Mathlib. Prepared for submission to
[Palomar](https://palomar-registry.org).

## The theorem

If smooth bounded functionals converge to zero in L² and their Malliavin
derivatives converge in L²(H), the limit derivative is zero. This is the
foundational estimate that makes the Malliavin derivative a closable operator,
enabling its extension from smooth test functionals to the Sobolev space
D^{1,2}. It adapts Proposition 1.2.1 in Nualart's *The Malliavin
Calculus and Related Topics* (2nd ed., Springer, doi:10.1007/3-540-28329-3)
to an abstract Gaussian Banach space with a bounded-C¹ core.

## Provenance

The proof library (`Malliavin/`) is extracted from
[lean-clark-ocone](https://github.com/savarin/lean-clark-ocone) at commit
`41d3f1509bc8f5c58ff3f17a4d9121ef4c3bb8a4`. Three files (CameronMartin, CameronMartinTheorem,
MalliavinDerivative) form the dependency chain for the closability result.

## Trust boundary

- **Challenge.lean** imports only Mathlib. It defines sorry-bodied stubs for
  `CameronMartin.Space`, `IsSmoothBounded.toLp`, and
  `IsSmoothBounded.mderivLp`, then states `mderiv_closable` with proof
  `sorry`.
- **Solution.lean** imports the full `Malliavin` library. It fills in the
  three definition holes and proves `mderiv_closable`.
- **comparator.json** lists one theorem and three definition holes.

A mathematical reader can audit the statement by reading Challenge.lean alone
(~75 lines, Mathlib-only imports).

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
scripts/negative_control.sh
```

## Axioms

`propext`, `Classical.choice`, `Quot.sound` — the standard Lean 4 axioms.

## License

Apache-2.0

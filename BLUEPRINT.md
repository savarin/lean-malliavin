# Blueprint

Plain-mathematics proof route for the Clark–Ocone representation
theorem on an abstract Gaussian Banach space.

## Target

For a Gaussian measure on a separable Banach space whose coordinate
functionals generate the measurable space: every square-integrable
functional F has the representation

    F = E[F] + ∫₀^∞ E[DₜF | Fₜ] dBₜ

where D is the Malliavin derivative (the Fréchet derivative along
Cameron–Martin directions, extended by graph closure), Fₜ is the
natural Brownian filtration, and the integral is the Itô stochastic
integral.

The proof constructs an abstract Hilbert-space contract — a
norm-isometric integration operator, its surjectivity, and a duality
identity — then obtains the formula by Riesz uniqueness in three
lines. All analytic difficulty lives in constructing one instance of
this contract on the natural Brownian filtration.

## Proof route

**Layer 1 — the Cameron–Martin space.** Take every centered
continuous linear functional on the Banach space, regard it as an
element of L²(μ), and close the span. This closed subspace is the
Cameron–Martin Hilbert space H. The covariance map embeds H back
into the ambient Banach space continuously and injectively.

**Layer 2 — quasi-invariance.** The Gaussian measure translated by a
Cameron–Martin vector is mutually absolutely continuous with the
original. The proof matches the translated measure and an
exponentially-tilted measure on every continuous dual functional
(Gaussian moment-generating function comparison), then invokes
uniqueness of a measure from its characteristic functions. This
sidesteps the classical cylinder-set Radon–Nikodym computation
entirely.

**Layer 3 — the Malliavin derivative, integration by parts,
closability.** For a bounded C¹ functional F, the Malliavin derivative
at x is the Riesz representative (in H) of the Fréchet derivative
composed with the covariance embedding. Integration by parts is
proved by differentiating the Layer 2 shift formula under the integral
sign at the origin of a one-parameter family, via dominated
convergence.

Closability (the derivative extends to a closed operator on a graph
closure domain) follows from an abstract Hilbert-space lemma: if a
linear operator has a total family of adjoint test vectors in the
codomain, and Fₙ → 0 with TFₙ → η, then η pairs to zero against
every test vector, so η = 0 by totality. The total family is the
set of simple tensors (smooth functional) ⊗ (Cameron–Martin vector);
density of smooth bounded functionals in L² is established separately
via Fourier-analytic test functions.

**Layer 4 — Wiener chaos decomposition (abstract).** For any process
satisfying only a covariance axiom (not yet genuine Brownian motion),
the simplex-symmetrization-iterated-integral machinery builds a
Hilbert-sum decomposition L² = ⊕ₙ (order-n chaos), using only
second-moment Gram-matrix identities. This is a purely algebraic
construction at the law level.

**Layer 5 — Wiener chaos decomposition (concrete Brownian).** The
abstract operators are identified with genuine iterated Itô integrals
built from real Brownian increment products (ordered-box
construction). The resulting closed chaos ranges sit inside the
closed range of the natural Itô integral — reducing "does the tower
span L²?" to "is the natural Itô integral surjective?" (martingale
representation).

Totality of the tower requires a hypothesis the textbook usually
hides: the process's coordinates must σ-generate the ambient
measurable space. Without this, a process defined on a product space
carrying extra independent randomness would fail to span L².

**Layer 6 — Hermite polynomials and totality.** Generalized Hermite
polynomials of finite Brownian step sums (Wick powers) are shown to
coincide with canonical multiple Wiener–Itô integrals of pure-power
kernels. The mechanism is a Malliavin–Itô duality recursion: the
Malliavin derivative of an order-n Wick power drops the order by one
and tensors with the step kernel, so the inner product of a Wick power
against an ordered Brownian increment chain peels off one factor per
inductive step via the duality identity. This computes the pairing
explicitly as n! times a product of one-dimensional inner products.
The canonical pure-power integral has the same pairings by a direct
kernel calculation. To conclude equality, ordered-box density shows
that finite unions of positive ordered time boxes are measure-dense in
the strict simplex, so ordered increment chains span a dense subspace
of each homogeneous chaos. A difference functional vanishing on a
dense set vanishes on the closure, giving equality at all orders.
Combined with density of polynomials in finitely many Brownian
coordinates and the algebraic-basis property of Hermite polynomials,
this gives genuine totality of the concrete chaos tower, hence
genuine natural martingale representation.

**Layer 7 — the natural-filtration Itô integral.** Built in stages:
the order-1 Wiener integral (isometry from L²(time) to L²(P)) is
constructed from a Gram-matrix matching argument and extension along
a dense range. Elementary adapted step processes are shown dense in
predictable L² (generating-π-system argument exhausting time from a
null origin), and the Itô isometry is extended from elementary
processes to the full predictable space by norm-preserving extension.

**Layer 8 — predictable projection and assembly.** The Clark–Ocone
integrand is the L² orthogonal projection of the Malliavin derivative
onto the predictable σ-algebra. Identifying this abstract projection
with the textbook E[DₜF | Fₜ] requires: (a) a Fubini-type lift
identifying H-valued random variables with time-indexed processes,
using that on a generated Wiener space the Cameron–Martin space is
the first chaos; (b) disintegration kernels restricted to a finite
time horizon; (c) almost-everywhere identification of product-space
predictable-projection kernels with fixed-time conditional-expectation
kernels; and (d) a left-continuity-mod-null-sets lemma for the natural
filtration, closing the predictable-vs-adapted regularity gap.

Given the contract (isometric integration, surjectivity, duality
identity), the Clark–Ocone representation is Riesz uniqueness: any
representer obtained from martingale representation must equal the
predictable-projected derivative because they pair identically against
every test vector and the integration operator is injective.

## Key lemmas

1. **Shift-versus-tilt identity.** The translated Gaussian measure
   equals the exponentially-tilted measure; proved via dual
   characteristic-function matching. The analytic core of Layer 2.

2. **Differentiate-the-shift-formula integration by parts.** Converts
   the shift identity into ∫ ⟨DF, h⟩ dμ = ∫ F · δ(h) dμ via a
   parametrized dominated-convergence differentiation — substantial
   real-analysis bookkeeping for a step textbooks state in one line.

3. **Abstract closability lemma.** Total adjoint family + graph-closed
   limit ⟹ the operator extends. Instantiated with simple tensors as
   the total family.

4. **The σ-generation hypothesis.** A non-optional totality condition.
   A pre-Brownian process on a product space carrying extra
   independent randomness would fail to span L².

5. **The Malliavin–Itô duality recursion and ordered-box density.**
   Identifies Wick powers with canonical pure-power integrals by
   computing their pairings against ordered increment chains via
   recursive application of the duality identity, then closing by
   density of ordered boxes in each homogeneous chaos. The single
   hardest unconditional step in the entire proof.

6. **Extension along a dense isometry.** Used twice — the Wiener
   integral and the full Itô integral — as the generic mechanism for
   building isometries from Gram-matrix matches on dense subspaces.

7. **Kernel identification almost everywhere.** Bridges the
   product-space predictable projection to fixed-time conditional
   expectation, valid only almost-everywhere in time.

8. **Riesz-uniqueness assembly.** The three-line abstract
   representation theorem that the entire library exists to feed.

## Pitfalls

1. **Quasi-invariance avoids cylinder-set Radon–Nikodym.** The
   textbook route (products of one-dimensional Gaussian densities on
   cylinder σ-algebras) is replaced by a finite-dimensional
   characteristic-function argument. Cleaner, but a reader expecting
   the classical proof will not recognize the route.

2. **"Differentiate both sides" is not free.** The one-directional
   integration-by-parts formula requires an explicit dominating
   function and appeal to a parametrized dominated-convergence theorem
   for derivatives under the integral — substantial real-analysis
   bookkeeping for a single-line textbook step.

3. **Two separate chaos towers must be reconciled.** An abstract
   law-level tower (needs only covariance axioms) and a concrete
   Brownian tower (needs genuine increment products) are proved
   separately and then identified. This split is invisible in
   textbook treatments that fix the canonical Wiener space from the
   start.

4. **The duality recursion is the bottleneck.** Everything at order
   ≤ 1 is free. The entire content of "spanning" is concentrated in
   the Malliavin–Itô duality recursion combined with ordered-box
   density at order ≥ 2.

5. **Predictable ≠ adapted, and it matters at one place.** The jump
   from fixed-time conditional expectation to predictable-σ-algebra
   projection is valid only almost-everywhere in time. The residual
   gap is closed by proving the natural filtration is left-continuous
   modulo null sets — a property specific to the natural filtration,
   not general filtrations.

6. **The representation theorem carries none of the analytic
   difficulty.** Once the abstract contract is stated, the formula is
   Riesz uniqueness in three lines. A reader who starts at the final
   assembly will be misled into thinking the theorem is easy; the
   difficulty is entirely in constructing one instance of the
   contract.

7. **The Sobolev domain is built from bounded functionals only.**
   Unbounded textbook examples (Brownian motion at a fixed time,
   polynomials of Brownian coordinates) need a separate
   arctan-cutoff dominated-convergence argument to enter the domain.

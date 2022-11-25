# Γ = {
#     ∀x ¬E(x, x),
#     ∀x∀y E(x, y) ⟹ E(y, x),
#     ∀x∃!y E(x, y)
# }

# ψ = expr(
#     "~E(x, x) & " *
#     "(~E(x, y) | E(y, x)) &" *
#     "Z(x) &" *
#     "(Z(x) | ~E(x, y)) &" *
#     "(Z(x) | S(x)) &" *
#     "(S(x) | ~E(x, y))"
# )

# eliminated Z(x) by unit propagation
ψ = parse_formula(
    "~E(x, x) & " *
    "(~E(x, y) | E(y, x)) &" *
    "(S(x) | ~E(x, y))"
)

# Results taken from https://oeis.org/A006129
@testset "$(typeof(algo))" for algo in [NoOptFastWFOMCAlgorithm(), FastWFOMCAlgorithm()]
    weights = WFOMCWeights{BigInt}(("S", 1) => (1, -1))
    fill_missing_weights!(weights, ψ)
    @test compute_wfomc(ψ, 0, weights; algo) == 1
    @test compute_wfomc(ψ, 1, weights; algo) == 0
    @test compute_wfomc(ψ, 2, weights; algo) == 1
    @test compute_wfomc(ψ, 3, weights; algo) == 4
    @test compute_wfomc(ψ, 4, weights; algo) == 41
    @test compute_wfomc(ψ, 5, weights; algo) == 768
    @test compute_wfomc(ψ, 6, weights; algo) == 27449
    @test compute_wfomc(ψ, 7, weights; algo) == 1887284
    @test compute_wfomc(ψ, 8, weights; algo) == 252522481
    @test compute_wfomc(ψ, 9, weights; algo) == 66376424160
    @test compute_wfomc(ψ, 10, weights; algo) == 34509011894545
    @test compute_wfomc(ψ, 11, weights; algo) == 35645504882731588
    @test compute_wfomc(ψ, 12, weights; algo) == 73356937912127722841
    @test compute_wfomc(ψ, 13, weights; algo) == 301275024444053951967648
    @test compute_wfomc(ψ, 14, weights; algo) == 2471655539737552842139838345
    @test compute_wfomc(ψ, 15, weights; algo) == 40527712706903544101000417059892

    weights = WFOMCWeights{fmpz}(("S", 1) => (1, -1))
    fill_missing_weights!(weights, ψ)
    @test compute_wfomc(ψ, 0, weights; algo) == 1
    @test compute_wfomc(ψ, 1, weights; algo) == 0
    @test compute_wfomc(ψ, 2, weights; algo) == 1
    @test compute_wfomc(ψ, 3, weights; algo) == 4
    @test compute_wfomc(ψ, 4, weights; algo) == 41
    @test compute_wfomc(ψ, 5, weights; algo) == 768
    @test compute_wfomc(ψ, 6, weights; algo) == 27449
    @test compute_wfomc(ψ, 7, weights; algo) == 1887284
    @test compute_wfomc(ψ, 8, weights; algo) == 252522481
    @test compute_wfomc(ψ, 9, weights; algo) == 66376424160
    @test compute_wfomc(ψ, 10, weights; algo) == 34509011894545
    @test compute_wfomc(ψ, 11, weights; algo) == 35645504882731588
    @test compute_wfomc(ψ, 12, weights; algo) == 73356937912127722841
    @test compute_wfomc(ψ, 13, weights; algo) == 301275024444053951967648
    @test compute_wfomc(ψ, 14, weights; algo) == 2471655539737552842139838345
    @test compute_wfomc(ψ, 15, weights; algo) == 40527712706903544101000417059892

    weights = WFOMCWeights{fmpq}(("S", 1) => (1, -1))
    fill_missing_weights!(weights, ψ)
    @test compute_wfomc(ψ, 0, weights; algo) == 1
    @test compute_wfomc(ψ, 1, weights; algo) == 0
    @test compute_wfomc(ψ, 2, weights; algo) == 1
    @test compute_wfomc(ψ, 3, weights; algo) == 4
    @test compute_wfomc(ψ, 4, weights; algo) == 41
    @test compute_wfomc(ψ, 5, weights; algo) == 768
    @test compute_wfomc(ψ, 6, weights; algo) == 27449
    @test compute_wfomc(ψ, 7, weights; algo) == 1887284
    @test compute_wfomc(ψ, 8, weights; algo) == 252522481
    @test compute_wfomc(ψ, 9, weights; algo) == 66376424160
    @test compute_wfomc(ψ, 10, weights; algo) == 34509011894545
    @test compute_wfomc(ψ, 11, weights; algo) == 35645504882731588
    @test compute_wfomc(ψ, 12, weights; algo) == 73356937912127722841
    @test compute_wfomc(ψ, 13, weights; algo) == 301275024444053951967648
    @test compute_wfomc(ψ, 14, weights; algo) == 2471655539737552842139838345
    @test compute_wfomc(ψ, 15, weights; algo) == 40527712706903544101000417059892

    px, x = PolynomialRing(QQ, "x")
    weights = WFOMCWeights{fmpq_poly}(("S", 1) => (px(1), px(-1)))
    fill_missing_weights!(weights, ψ)
    @test compute_wfomc(ψ, 0, weights; algo) == 1
    @test compute_wfomc(ψ, 1, weights; algo) == 0
    @test compute_wfomc(ψ, 2, weights; algo) == 1
    @test compute_wfomc(ψ, 3, weights; algo) == 4
    @test compute_wfomc(ψ, 4, weights; algo) == 41
    @test compute_wfomc(ψ, 5, weights; algo) == 768
    @test compute_wfomc(ψ, 6, weights; algo) == 27449
    @test compute_wfomc(ψ, 7, weights; algo) == 1887284
    @test compute_wfomc(ψ, 8, weights; algo) == 252522481
    @test compute_wfomc(ψ, 9, weights; algo) == 66376424160
    @test compute_wfomc(ψ, 10, weights; algo) == 34509011894545
    @test compute_wfomc(ψ, 11, weights; algo) == 35645504882731588
    @test compute_wfomc(ψ, 12, weights; algo) == 73356937912127722841
    @test compute_wfomc(ψ, 13, weights; algo) == 301275024444053951967648
    @test compute_wfomc(ψ, 14, weights; algo) == 2471655539737552842139838345
    @test compute_wfomc(ψ, 15, weights; algo) == 40527712706903544101000417059892

    px, x = PolynomialRing(ZZ, "x")
    weights = WFOMCWeights{fmpz_poly}(("S", 1) => (px(1), px(-1)))
    fill_missing_weights!(weights, ψ)
    @test compute_wfomc(ψ, 0, weights; algo) == 1
    @test compute_wfomc(ψ, 1, weights; algo) == 0
    @test compute_wfomc(ψ, 2, weights; algo) == 1
    @test compute_wfomc(ψ, 3, weights; algo) == 4
    @test compute_wfomc(ψ, 4, weights; algo) == 41
    @test compute_wfomc(ψ, 5, weights; algo) == 768
    @test compute_wfomc(ψ, 6, weights; algo) == 27449
    @test compute_wfomc(ψ, 7, weights; algo) == 1887284
    @test compute_wfomc(ψ, 8, weights; algo) == 252522481
    @test compute_wfomc(ψ, 9, weights; algo) == 66376424160
    @test compute_wfomc(ψ, 10, weights; algo) == 34509011894545
    @test compute_wfomc(ψ, 11, weights; algo) == 35645504882731588
    @test compute_wfomc(ψ, 12, weights; algo) == 73356937912127722841
    @test compute_wfomc(ψ, 13, weights; algo) == 301275024444053951967648
    @test compute_wfomc(ψ, 14, weights; algo) == 2471655539737552842139838345
    @test compute_wfomc(ψ, 15, weights; algo) == 40527712706903544101000417059892

    poly, vars = PolynomialRing(QQ, ["x", "y"])
    weights = WFOMCWeights{fmpq_mpoly}(("S", 1) => (poly(1), poly(-1)))
    fill_missing_weights!(weights, ψ)
    @test compute_wfomc(ψ, 0, weights; algo) == 1
    @test compute_wfomc(ψ, 1, weights; algo) == 0
    @test compute_wfomc(ψ, 2, weights; algo) == 1
    @test compute_wfomc(ψ, 3, weights; algo) == 4
    @test compute_wfomc(ψ, 4, weights; algo) == 41
    @test compute_wfomc(ψ, 5, weights; algo) == 768
    @test compute_wfomc(ψ, 6, weights; algo) == 27449
    @test compute_wfomc(ψ, 7, weights; algo) == 1887284
    @test compute_wfomc(ψ, 8, weights; algo) == 252522481
    @test compute_wfomc(ψ, 9, weights; algo) == 66376424160
    @test compute_wfomc(ψ, 10, weights; algo) == 34509011894545
    @test compute_wfomc(ψ, 11, weights; algo) == 35645504882731588
    @test compute_wfomc(ψ, 12, weights; algo) == 73356937912127722841
    @test compute_wfomc(ψ, 13, weights; algo) == 301275024444053951967648
    @test compute_wfomc(ψ, 14, weights; algo) == 2471655539737552842139838345
    @test compute_wfomc(ψ, 15, weights; algo) == 40527712706903544101000417059892

    poly, vars = PolynomialRing(ZZ, ["x", "y"])
    weights = WFOMCWeights{fmpz_mpoly}(("S", 1) => (poly(1), poly(-1)))
    fill_missing_weights!(weights, ψ)
    @test compute_wfomc(ψ, 0, weights; algo) == 1
    @test compute_wfomc(ψ, 1, weights; algo) == 0
    @test compute_wfomc(ψ, 2, weights; algo) == 1
    @test compute_wfomc(ψ, 3, weights; algo) == 4
    @test compute_wfomc(ψ, 4, weights; algo) == 41
    @test compute_wfomc(ψ, 5, weights; algo) == 768
    @test compute_wfomc(ψ, 6, weights; algo) == 27449
    @test compute_wfomc(ψ, 7, weights; algo) == 1887284
    @test compute_wfomc(ψ, 8, weights; algo) == 252522481
    @test compute_wfomc(ψ, 9, weights; algo) == 66376424160
    @test compute_wfomc(ψ, 10, weights; algo) == 34509011894545
    @test compute_wfomc(ψ, 11, weights; algo) == 35645504882731588
    @test compute_wfomc(ψ, 12, weights; algo) == 73356937912127722841
    @test compute_wfomc(ψ, 13, weights; algo) == 301275024444053951967648
    @test compute_wfomc(ψ, 14, weights; algo) == 2471655539737552842139838345
    @test compute_wfomc(ψ, 15, weights; algo) == 40527712706903544101000417059892
end

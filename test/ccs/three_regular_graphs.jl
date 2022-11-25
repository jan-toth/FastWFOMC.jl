ψ = parse_formula(
    "~E(x, x) & " *
    "(~E(x, y) | E(y, x)) & " *
    "(~F(x, y) | E(x, y)) & " *
    "(F(x, y) | ~E(x, y)) & " *
    "(S1(x) | ~F1(x, y)) & " *
    "(S2(x) | ~F2(x, y)) & " *
    "(S3(x) | ~F3(x, y)) & " *
    "(~F(x, y) | F1(x, y) | F2(x, y) | F3(x, y)) & " *
    "(F(x, y) | ~F1(x, y)) & " *
    "(F(x, y) | ~F2(x, y)) & " *
    "(F(x, y) | ~F3(x, y)) & " *
    "(~F1(x, y) | ~F2(x, y)) & " *
    "(~F1(x, y) | ~F3(x, y)) & " *
    "(~F2(x, y) | ~F3(x, y))"
)

weights = WFOMCWeights{Rational{BigInt}}(("S1", 1) => (1, -1), ("S2", 1) => (1, -1), ("S3", 1) => (1, -1))
fill_missing_weights!(weights, ψ)


for n = 1:2:20
    cc = CardinalityConstraint(("F", 2), 3 * n)
    @test compute_wfomc(ψ, n, weights; ccs=[cc]) // big(6)^n == 0
end

n = 0
cc = CardinalityConstraint(("F", 2), 3 * n)
@test compute_wfomc(ψ, n, weights; ccs=[cc]) // big(6)^n == 1

n = 2
cc = CardinalityConstraint(("F", 2), 3 * n)
@test compute_wfomc(ψ, n, weights; ccs=[cc]) // big(6)^n == 0

n = 4
cc = CardinalityConstraint(("F", 2), 3 * n)
@test compute_wfomc(ψ, n, weights; ccs=[cc]) // big(6)^n == 1

n = 6
cc = CardinalityConstraint(("F", 2), 3 * n)
@test compute_wfomc(ψ, n, weights; ccs=[cc]) // big(6)^n == 70

n = 8
cc = CardinalityConstraint(("F", 2), 3 * n)
@test compute_wfomc(ψ, n, weights; ccs=[cc]) // big(6)^n == 19355

n = 10
cc = CardinalityConstraint(("F", 2), 3 * n)
@test compute_wfomc(ψ, n, weights; ccs=[cc]) // big(6)^n == 11180820

n = 12
cc = CardinalityConstraint(("F", 2), 3 * n)
@test compute_wfomc(ψ, n, weights; ccs=[cc]) // big(6)^n == 11555272575

n = 14
cc = CardinalityConstraint(("F", 2), 3 * n)
@test compute_wfomc(ψ, n, weights; ccs=[cc]) // big(6)^n == 19506631814670

n = 16
cc = CardinalityConstraint(("F", 2), 3 * n)
@test compute_wfomc(ψ, n, weights; ccs=[cc]) // big(6)^n == 50262958713792825

n = 18
cc = CardinalityConstraint(("F", 2), 3 * n)
@test compute_wfomc(ψ, n, weights; ccs=[cc]) // big(6)^n == 187747837889699887800

n = 20
cc = CardinalityConstraint(("F", 2), 3 * n)
@test compute_wfomc(ψ, n, weights; ccs=[cc]) // big(6)^n == 976273961160363172131825

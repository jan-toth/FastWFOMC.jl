using FastWFOMC

five_coloured = expr(
    "~E(x, x) & " *
    "(~E(x, y) | E(y, x)) & " *
    "(C1(x) | C2(x) | C3(x) | C4(x) | C5(x)) & " *
    "(~C1(x) | ~C2(x)) & " *
    "(~C2(x) | ~C3(x)) & " *
    "(~C1(x) | ~C3(x)) & " *
    "(~C1(x) | ~C4(x)) & " *
    "(~C2(x) | ~C4(x)) & " *
    "(~C3(x) | ~C4(x)) & " *
    "(~C1(x) | ~C5(x)) & " *
    "(~C2(x) | ~C5(x)) & " *
    "(~C3(x) | ~C5(x)) & " *
    "(~C4(x) | ~C5(x)) & " *
    "(~E(x,y) | (~(C1(x) & C1(y)) & ~(C2(x) & C2(y)) & ~(C3(x) & C3(y)) & ~(C4(x) & C4(y)) & ~(C5(x) & C5(y))))"
)

ψ = expr(
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

n = 6
w = WFOMCWeights{Rational{BigInt}}("S1" => (1, -1), "S2" => (1, -1), "S3" => (1, -1))
cc = CardinalityConstraint("F", 3n)
fill_missing_weights!(w, ψ)

# 3265920 / (3!)^6  = 70
compute_wfomc(ψ, n, w, cc) // factorial(big(3))^n

using Nemo

function construct_polynomial(ring, exponents, coeffs)
    res = zero(ring)
    for (exp, coeff) in zip(exponents, coeffs)
        term = ring(coeff)
        set_exponent_vector!(term, 1, exp)
        res += term
    end
    return res
end

S, vars = PolynomialRing(QQ, 2)
n = 6
w = WFOMCWeights{fpmq_mpoly}("S1" => (one(S), -one(S)), "S2" => (one(S), -one(S)), "S3" => (one(S), -one(S)))
w["E"] = (vars[1], one(S))
cc = CardinalityConstraint("F", 3n)
fill_missing_weights!(w, ψ)
compute_wfomc(ψ, n, w, cc)

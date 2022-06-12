using FastWFOMC

function compute_sequence(ψ, weights, maxterm)
    compute_wfomc(ψ, 0, weights) # compile

    @time for n = 0:maxterm
        @time compute_wfomc(ψ, n, weights)
        flush(stdout)
    end
end

function compute_sequence(ψ, weights, ccs_cb, maxterm)
    println("Compiling...")
    compute_wfomc(ψ, 0, weights; ccs=[ccs_cb(0)])

    println("Benchmarking...")
    for n = 0:2:2*maxterm
        @time compute_wfomc(ψ, n, weights; ccs=[ccs_cb(n)])
        flush(stdout)
    end
end

ψ₁ = parse_formula(
    # 3-coloured
    "~E(x, x) & " *
    "(~E(x, y) | E(y, x)) & " *
    "(C1(x) | C2(x) | C3(x)) & " *
    "(~C1(x) | ~C2(x)) & " *
    "(~C2(x) | ~C3(x)) & " *
    "(~C1(x) | ~C3(x)) & " *
    "(~E(x,y) | (~(C1(x) & C1(y)) & ~(C2(x) & C2(y)) & ~(C3(x) & C3(y)))) & " *

    # two regular
    "(~F(x, y) | E(x, y)) & " *  # (5)
    "(F(x, y) | ~E(x, y)) & " *  # (5)
    "(S1(x) | ~F1(x, y)) & " *  # (7)
    "(S2(x) | ~F2(x, y)) & " *  # (8)
    "(~F(x, y) | F1(x, y) | F2(x, y)) & " *  # (9)
    "(F(x, y) | ~F1(x, y)) & " *  # (9)
    "(F(x, y) | ~F2(x, y)) & " *  # (9)
    "(~F1(x, y) | ~F2(x, y))"  # (10)
)

ψ₂ = parse_formula(
    # 2-coloured
    "~E(x, x) & " *
    "(~E(x, y) | E(y, x)) & " *
    "(C1(x) | C2(x)) & " *
    "(~C1(x) | ~C2(x)) & " *
    "(~E(x,y) | (~(C1(x) & C1(y)) & ~(C2(x) & C2(y)))) & " *

    # two regular
    "(~F(x, y) | E(x, y)) & " *  # (5)
    "(F(x, y) | ~E(x, y)) & " *  # (5)
    "(S1(x) | ~F1(x, y)) & " *  # (7)
    "(S2(x) | ~F2(x, y)) & " *  # (8)
    "(~F(x, y) | F1(x, y) | F2(x, y)) & " *  # (9)
    "(F(x, y) | ~F1(x, y)) & " *  # (9)
    "(F(x, y) | ~F2(x, y)) & " *  # (9)
    "(~F1(x, y) | ~F2(x, y))"  # (10)  
)

weights = WFOMCWeights{Rational{BigInt}}("S1" => (1, -1), "S2" => (1, -1))
fill_missing_weights!(weights, ψ₁)
ccs_cb = domsize -> CardinalityConstraint("F", 2domsize)

compute_sequence(ψ₂, weights, ccs_cb, 40)

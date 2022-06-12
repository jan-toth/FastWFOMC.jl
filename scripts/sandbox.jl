using FastWFOMC

five_coloured = parse_formula(
    join(
        [
            "~E(x, x)",             # no loops
            "(~E(x, y) | E(y, x))", # undirected
            "(C1(x) | C2(x) | C3(x) | C4(x) | C5(x))", # at least one colour
            
            # at most one colour
            "(~C1(x) | ~C2(x))",
            "(~C2(x) | ~C3(x))",
            "(~C1(x) | ~C3(x))",
            "(~C1(x) | ~C4(x))",
            "(~C2(x) | ~C4(x))",
            "(~C3(x) | ~C4(x))",
            "(~C1(x) | ~C5(x))",
            "(~C2(x) | ~C5(x))",
            "(~C3(x) | ~C5(x))",
            "(~C4(x) | ~C5(x))",

            # prohibit same colour connections
            "(~E(x,y) | (~(C1(x) & C1(y)) & ~(C2(x) & C2(y)) & ~(C3(x) & C3(y)) & ~(C4(x) & C4(y)) & ~(C5(x) & C5(y))))"
        ],
    " & ")
)

println("No. 5-coloured graphs on n vertices:")
for n = 0:10
    fomc = compute_wfomc(five_coloured, n)  # weights all set to one
    @show(n, fomc)
end


println("===========================")


three_regular = parse_formula(
    join(
        [
            "~E(x, x)",
            "(~E(x, y) | E(y, x))",
            "(~F(x, y) | E(x, y))",
            "(F(x, y) | ~E(x, y))",
            "(S1(x) | ~F1(x, y))",
            "(S2(x) | ~F2(x, y))",
            "(S3(x) | ~F3(x, y))",
            "(~F(x, y) | F1(x, y) | F2(x, y) | F3(x, y))",
            "(F(x, y) | ~F1(x, y))",
            "(F(x, y) | ~F2(x, y))",
            "(F(x, y) | ~F3(x, y))",
            "(~F1(x, y) | ~F2(x, y))",
            "(~F1(x, y) | ~F3(x, y))",
            "(~F2(x, y) | ~F3(x, y))"

        ],
    " & ")
)

weights = WFOMCWeights{Rational{BigInt}}("S1" => (1, -1), "S2" => (1, -1), "S3" => (1, -1))
fill_missing_weights!(weights, three_regular)  # set unset weights to 1


println("No. 3-regular graphs on n vertices:")
for n = 0:2:10
    fomc = @time compute_wfomc(three_regular, n, weights; ccs=[CardinalityConstraint("F", 3n)]) // big(6)^n
    @show(n, fomc)
end

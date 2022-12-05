using FastWFOMC



sentence = "(S0 | Z0(x)) & (Z0(x) | S0(x)) & (Z0(x) | B0(x, y)) & (S0(x) | B0(x, y)) & (S0 | Z0(x)) & (Z0(x) | S0(x)) & (Z0(x) | B0(y, x)) & (S0(x) | B0(y, x))"

get_cell_graph(sentence) |> println



parsed = parse_formula(sentence)

weights = WFOMCWeights{Rational{BigInt}}(
	("S0", 0) => (1//1, -1//1),
	("S0", 1) => (1//1, -1//1)
)

fill_missing_weights!(weights, parsed, big"1"//1)
fomc = compute_wfomc(parsed, 5, weights; ccs=[])
@assert isone(denominator(fomc))
string(numerator(fomc)) |> println

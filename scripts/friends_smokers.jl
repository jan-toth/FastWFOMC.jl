# using Revise
using FastWFOMC
using FastWFOMC: WFOMC, compute_wfomc_fo2

using ProgressMeter

friends_and_smokers = parse_formula("~Sm(x) | ~Fr(x, y) | Sm(y)")

@showprogress for n = 0:20
    compute_wfomc_fo2(WFOMC(friends_and_smokers, n, WFOMCWeights("Sm" => (1.0, 1.0), "Fr" => (4.0, 1.0))), NoOptFastWFOMCAlgorithm())
    compute_wfomc_fo2(WFOMC(friends_and_smokers, n, WFOMCWeights("Sm" => (1.0, 1.0), "Fr" => (4.0, 1.0))), FastWFOMCAlgorithm())
end

# 4_375_000
compute_wfomc_fo2(WFOMC(parse_formula("~Sm(x) | ~Fr(x, y) | Sm(y)"), 3, WFOMCWeights("Sm" => (1.0, 1.0), "Fr" => (4.0, 1.0))), NoOptFastWFOMCAlgorithm()) |> println
compute_wfomc_fo2(WFOMC(parse_formula("~Sm(x) | ~Fr(x, y) | Sm(y)"), 3, WFOMCWeights("Sm" => (1.0, 1.0), "Fr" => (4.0, 1.0))), FastWFOMCAlgorithm()) |> println

# 316_406_250_000
compute_wfomc_fo2(WFOMC(parse_formula("~Sm(x) | ~Fr(x, y) | Sm(y)"), 4, WFOMCWeights{Rational{BigInt}}("Sm" => (1.0, 1.0), "Fr" => (4.0, 1.0))), NoOptFastWFOMCAlgorithm()) |> println
compute_wfomc_fo2(WFOMC(parse_formula("~Sm(x) | ~Fr(x, y) | Sm(y)"), 4, WFOMCWeights{Rational{BigInt}}("Sm" => (1.0, 1.0), "Fr" => (4.0, 1.0))), FastWFOMCAlgorithm()) |> println

# 601_196_289_062_500_000
compute_wfomc_fo2(WFOMC(parse_formula("~Sm(x) | ~Fr(x, y) | Sm(y)"), 5, WFOMCWeights{Rational{BigInt}}("Sm" => (1.0, 1.0), "Fr" => (4.0, 1.0))), NoOptFastWFOMCAlgorithm()) |> println
compute_wfomc_fo2(WFOMC(parse_formula("~Sm(x) | ~Fr(x, y) | Sm(y)"), 5, WFOMCWeights{Rational{BigInt}}("Sm" => (1.0, 1.0), "Fr" => (4.0, 1.0))), FastWFOMCAlgorithm()) |> println


# 29160976409912109375000000
compute_wfomc_fo2(WFOMC(parse_formula("~Sm(x) | ~Fr(x, y) | Sm(y)"), 6, WFOMCWeights{Rational{BigInt}}("Sm" => (1.0, 1.0), "Fr" => (4.0, 1.0))), NoOptFastWFOMCAlgorithm()) |> println
compute_wfomc_fo2(WFOMC(parse_formula("~Sm(x) | ~Fr(x, y) | Sm(y)"), 6, WFOMCWeights{Rational{BigInt}}("Sm" => (1.0, 1.0), "Fr" => (4.0, 1.0))), FastWFOMCAlgorithm()) |> println

# 35543134436011314392089843750000000
compute_wfomc_fo2(WFOMC(parse_formula("~Sm(x) | ~Fr(x, y) | Sm(y)"), 7, WFOMCWeights{Rational{BigInt}}("Sm" => (1.0, 1.0), "Fr" => (4.0, 1.0))), NoOptFastWFOMCAlgorithm()) |> println
compute_wfomc_fo2(WFOMC(parse_formula("~Sm(x) | ~Fr(x, y) | Sm(y)"), 7, WFOMCWeights{Rational{BigInt}}("Sm" => (1.0, 1.0), "Fr" => (4.0, 1.0))), FastWFOMCAlgorithm()) |> println

# 15777298888433854409316103861726787727093324065208435058593750000000000
compute_wfomc_fo2(WFOMC(parse_formula("~Sm(x) | ~Fr(x, y) | Sm(y)"), 10, WFOMCWeights{Rational{BigInt}}("Sm" => (1.0, 1.0), "Fr" => (4.0, 1.0))), NoOptFastWFOMCAlgorithm()) |> println
compute_wfomc_fo2(WFOMC(parse_formula("~Sm(x) | ~Fr(x, y) | Sm(y)"), 10, WFOMCWeights{Rational{BigInt}}("Sm" => (1.0, 1.0), "Fr" => (4.0, 1.0))), FastWFOMCAlgorithm()) |> println

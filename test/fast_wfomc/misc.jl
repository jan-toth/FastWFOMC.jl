@testset "Exists x P(x)" begin
    
    # ∃ x P(x)
    ϕ = parse_formula("~P(x) | S")
    weights = WFOMCWeights{Rational{BigInt}}(("S", 0) => (1, -1))
    fill_missing_weights!(weights, ϕ)


    for n in 1:100
        @test compute_wfomc(ϕ, n, weights) == big"2"^n - 1
    end
end


@testset "No models" begin
    # ∀ x ∀ y B0(x, y)) & (∃ x ∀ y ~B0(x, y))
    ϕ = parse_formula("(B0(x, y)) & (S0 | Z0(x)) & (Z0(x) | S0(x)) & (Z0(x) | ~B0(x, y)) & (S0(x) | ~B0(x, y))")
    weights = WFOMCWeights{Rational{BigInt}}(("S0",0)=>(1,-1), ("S0", 1)=>(1,-1))
    fill_missing_weights!(weights, ϕ)

    for n in 1:100
        @test compute_wfomc(ϕ, n, weights) == 0
    end
end

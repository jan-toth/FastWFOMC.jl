ψ = parse_formula(
    "~E(x, x) & " *
    "(~E(x, y) | E(y, x))"
)

# Results taken from https://oeis.org/A006125
@testset "$(typeof(algo))" for algo in [NoOptFastWFOMCAlgorithm(), FastWFOMCAlgorithm()]
    w = WFOMCWeights{Float64}()
    fill_missing_weights!(w, ψ)
    @test compute_wfomc(ψ, 0, w; algo) ≈ 1
    @test compute_wfomc(ψ, 1, w; algo) ≈ 1
    @test compute_wfomc(ψ, 2, w; algo) ≈ 2
    @test compute_wfomc(ψ, 3, w; algo) ≈ 8
    @test compute_wfomc(ψ, 4, w; algo) ≈ 64
    @test compute_wfomc(ψ, 5, w; algo) ≈ 1024
    @test compute_wfomc(ψ, 6, w; algo) ≈ 32768
    @test compute_wfomc(ψ, 7, w; algo) ≈ 2097152
    @test compute_wfomc(ψ, 8, w; algo) ≈ 268435456

    w = WFOMCWeights{BigFloat}()
    fill_missing_weights!(w, ψ)
    @test compute_wfomc(ψ, 0, w; algo) ≈ 1
    @test compute_wfomc(ψ, 1, w; algo) ≈ 1
    @test compute_wfomc(ψ, 2, w; algo) ≈ 2
    @test compute_wfomc(ψ, 3, w; algo) ≈ 8
    @test compute_wfomc(ψ, 4, w; algo) ≈ 64
    @test compute_wfomc(ψ, 5, w; algo) ≈ 1024
    @test compute_wfomc(ψ, 6, w; algo) ≈ 32768
    @test compute_wfomc(ψ, 7, w; algo) ≈ 2097152
    @test compute_wfomc(ψ, 8, w; algo) ≈ 268435456
    @test compute_wfomc(ψ, 9, w; algo) ≈ 68719476736
    @test compute_wfomc(ψ, 10, w; algo) ≈ 35184372088832
    @test compute_wfomc(ψ, 11, w; algo) ≈ 36028797018963968
    @test compute_wfomc(ψ, 12, w; algo) ≈ 73786976294838206464
    @test compute_wfomc(ψ, 13, w; algo) ≈ 302231454903657293676544
    @test compute_wfomc(ψ, 14, w; algo) ≈ 2475880078570760549798248448
    @test compute_wfomc(ψ, 15, w; algo) ≈ 40564819207303340847894502572032

    w = WFOMCWeights{Int}()
    fill_missing_weights!(w, ψ)
    @test compute_wfomc(ψ, 0, w; algo) == 1
    @test compute_wfomc(ψ, 1, w; algo) == 1
    @test compute_wfomc(ψ, 2, w; algo) == 2
    @test compute_wfomc(ψ, 3, w; algo) == 8
    @test compute_wfomc(ψ, 4, w; algo) == 64
    @test compute_wfomc(ψ, 5, w; algo) == 1024
    @test compute_wfomc(ψ, 6, w; algo) == 32768
    @test compute_wfomc(ψ, 7, w; algo) == 2097152
    @test compute_wfomc(ψ, 8, w; algo) == 268435456

    w = WFOMCWeights{BigInt}()
    fill_missing_weights!(w, ψ)
    @test compute_wfomc(ψ, 0, w; algo) == 1
    @test compute_wfomc(ψ, 1, w; algo) == 1
    @test compute_wfomc(ψ, 2, w; algo) == 2
    @test compute_wfomc(ψ, 3, w; algo) == 8
    @test compute_wfomc(ψ, 4, w; algo) == 64
    @test compute_wfomc(ψ, 5, w; algo) == 1024
    @test compute_wfomc(ψ, 6, w; algo) == 32768
    @test compute_wfomc(ψ, 7, w; algo) == 2097152
    @test compute_wfomc(ψ, 8, w; algo) == 268435456
    @test compute_wfomc(ψ, 9, w; algo) == 68719476736
    @test compute_wfomc(ψ, 10, w; algo) == 35184372088832
    @test compute_wfomc(ψ, 11, w; algo) == 36028797018963968
    @test compute_wfomc(ψ, 12, w; algo) == 73786976294838206464
    @test compute_wfomc(ψ, 13, w; algo) == 302231454903657293676544
    @test compute_wfomc(ψ, 14, w; algo) == 2475880078570760549798248448
    @test compute_wfomc(ψ, 15, w; algo) == 40564819207303340847894502572032

    w = WFOMCWeights{fmpz}()
    fill_missing_weights!(w, ψ)
    @test compute_wfomc(ψ, 0, w; algo) == 1
    @test compute_wfomc(ψ, 1, w; algo) == 1
    @test compute_wfomc(ψ, 2, w; algo) == 2
    @test compute_wfomc(ψ, 3, w; algo) == 8
    @test compute_wfomc(ψ, 4, w; algo) == 64
    @test compute_wfomc(ψ, 5, w; algo) == 1024
    @test compute_wfomc(ψ, 6, w; algo) == 32768
    @test compute_wfomc(ψ, 7, w; algo) == 2097152
    @test compute_wfomc(ψ, 8, w; algo) == 268435456
    @test compute_wfomc(ψ, 9, w; algo) == 68719476736
    @test compute_wfomc(ψ, 10, w; algo) == 35184372088832
    @test compute_wfomc(ψ, 11, w; algo) == 36028797018963968
    @test compute_wfomc(ψ, 12, w; algo) == 73786976294838206464
    @test compute_wfomc(ψ, 13, w; algo) == 302231454903657293676544
    @test compute_wfomc(ψ, 14, w; algo) == 2475880078570760549798248448
    @test compute_wfomc(ψ, 15, w; algo) == 40564819207303340847894502572032

    w = WFOMCWeights{fmpq}()
    fill_missing_weights!(w, ψ)
    @test compute_wfomc(ψ, 0, w; algo) == 1
    @test compute_wfomc(ψ, 1, w; algo) == 1
    @test compute_wfomc(ψ, 2, w; algo) == 2
    @test compute_wfomc(ψ, 3, w; algo) == 8
    @test compute_wfomc(ψ, 4, w; algo) == 64
    @test compute_wfomc(ψ, 5, w; algo) == 1024
    @test compute_wfomc(ψ, 6, w; algo) == 32768
    @test compute_wfomc(ψ, 7, w; algo) == 2097152
    @test compute_wfomc(ψ, 8, w; algo) == 268435456
    @test compute_wfomc(ψ, 9, w; algo) == 68719476736
    @test compute_wfomc(ψ, 10, w; algo) == 35184372088832
    @test compute_wfomc(ψ, 11, w; algo) == 36028797018963968
    @test compute_wfomc(ψ, 12, w; algo) == 73786976294838206464
    @test compute_wfomc(ψ, 13, w; algo) == 302231454903657293676544
    @test compute_wfomc(ψ, 14, w; algo) == 2475880078570760549798248448
    @test compute_wfomc(ψ, 15, w; algo) == 40564819207303340847894502572032

    # Rational{BigInt}
    @test compute_wfomc(ψ, 0; algo) == 1
    @test compute_wfomc(ψ, 1; algo) == 1
    @test compute_wfomc(ψ, 2; algo) == 2
    @test compute_wfomc(ψ, 3; algo) == 8
    @test compute_wfomc(ψ, 4; algo) == 64
    @test compute_wfomc(ψ, 5; algo) == 1024
    @test compute_wfomc(ψ, 6; algo) == 32768
    @test compute_wfomc(ψ, 7; algo) == 2097152
    @test compute_wfomc(ψ, 8; algo) == 268435456
    @test compute_wfomc(ψ, 9; algo) == 68719476736
    @test compute_wfomc(ψ, 10; algo) == 35184372088832
    @test compute_wfomc(ψ, 11; algo) == 36028797018963968
    @test compute_wfomc(ψ, 12; algo) == 73786976294838206464
    @test compute_wfomc(ψ, 13; algo) == 302231454903657293676544
    @test compute_wfomc(ψ, 14; algo) == 2475880078570760549798248448
    @test compute_wfomc(ψ, 15; algo) == 40564819207303340847894502572032
end

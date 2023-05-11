
@testset "Head & Tail" begin
    
    @testset "LEQ predicate" begin
        axioms = expr("LEQ(x, x)")
        
        #=
            A(x) & y > x => A(y)
        =#
        ψ = expr("~A(x) | LEQ(y, x) | A(y)") & axioms
        for n in 1:103
            @test compute_wfomc(ψ, n; algo=LinearOrderWFOMCAlgorithm()) == factorial(big(n)) * (n+1)
        end


        #=
            A(x) | B(x)
            ~A(x) | ~B(x)
            B(x) & x < y => B(y)
        =#
        ψ = expr("
                (A(x) | B(x)) &
                (~A(x) | ~B(x)) &
                (~B(x) | LEQ(y, x) | B(y))"
            ) & axioms
        for n in 1:103
            @test compute_wfomc(ψ, n; algo=LinearOrderWFOMCAlgorithm()) == factorial(big(n)) * (n+1)
        end


        #=
            A(x) | B(x)
            ~A(x) | ~B(x)
            A(x) & x > y => A(y)
        =#
        ψ = expr("
                (A(x) | B(x)) &
                (~A(x) | ~B(x)) &
                (~A(x) | LEQ(x, y) | A(y))"
            ) & axioms
        for n in 1:103
            @test compute_wfomc(ψ, n; algo=LinearOrderWFOMCAlgorithm()) == factorial(big(n)) * (n+1)
        end


        #=
            A(x) | B(x)
            ~A(x) | ~B(x)
            A(x) & x > y => A(y)
            B(x) & x < y => B(y)
        =#
        ψ = expr("
                (A(x) | B(x)) &
                (~A(x) | ~B(x)) &
                (~A(x) | LEQ(x, y) | A(y)) &
                (~B(x) | LEQ(y, x) | B(y))"
            ) & axioms
        for n in 1:103
            @test compute_wfomc(ψ, n; algo=LinearOrderWFOMCAlgorithm()) == factorial(big(n)) * (n+1)
        end
    end
    

    @testset "LESS predicate" begin
        axioms = expr("(LESS(x,y) <=> (LEQ(x, y) & ~LEQ(y, x))) & LEQ(x,x) & ~LESS(x,x)")

        #=
            B(x) & x < y => B(y)
        =#
        ψ = expr("~B(x) | ~LESS(y, x) | B(y)") & axioms
        for n in 1:103
            @test compute_wfomc(ψ, n; algo=LinearOrderWFOMCAlgorithm()) == factorial(big(n)) * (n+1)
        end


        #=
            A(x) | B(x)
            ~A(x) | ~B(x)
            B(x) & x < y => B(y)
        =#
        ψ = expr("
                (A(x) | B(x)) &
                (~A(x) | ~B(x)) &
                (~B(x) | ~LESS(x, y) | B(y))"
            ) & axioms
        for n in 1:103
            @test compute_wfomc(ψ, n; algo=LinearOrderWFOMCAlgorithm()) == factorial(big(n)) * (n+1)
        end

        #=
            A(x) | B(x)
            ~A(x) | ~B(x)
            A(x) & y < x => A(y)
        =#
        ψ = expr("
                (A(x) | B(x)) &
                (~A(x) | ~B(x)) &
                (~A(x) | ~LESS(y, x) | A(y))"
            ) & axioms
        for n in 1:103
            @test compute_wfomc(ψ, n; algo=LinearOrderWFOMCAlgorithm()) == factorial(big(n)) * (n+1)
        end

        #=
            A(x) | B(x)
            ~A(x) | ~B(x)
            B(x) & x < y => B(y)
            A(x) & x > y => A(y)
        =#
        ψ = expr("
                (A(x) | B(x)) &
                (~A(x) | ~B(x)) &
                (~B(x) | ~LESS(x, y) | B(y)) &
                (~A(x) | ~LESS(y, x) | A(y))"
            ) & axioms
        for n in 1:103
            @test compute_wfomc(ψ, n; algo=LinearOrderWFOMCAlgorithm()) == factorial(big(n)) * (n+1)
        end
    end

    
end

@testset "Head, Middle & Tail" begin
    axioms = expr("(LESS(x,y) <=> (LEQ(x, y) & ~LEQ(y, x))) & LEQ(x,x) & ~LESS(x,x)")

    #=
        A(x) + B(x) + C(x) >= 1
        A(x) + B(x) + C(x) <= 1
        A(x) & x < y => A(y)
        C(x) & x > y => C(y)
        ... everything else is B, aka the middle
    =#
    ψ = expr("
            (A(x) | B(x) | C(x)) &
            (~A(x) | ~B(x)) &
            (~A(x) | ~C(x)) &
            (~C(x) | ~B(x)) &
            (~C(x) | ~LESS(y, x) | C(y)) &
            (~A(x) | ~LESS(x, y) | A(y))"
        ) & axioms
    for n in 1:36
        @test compute_wfomc(ψ, n; algo=LinearOrderWFOMCAlgorithm()) == factorial(big(n)) * ((n + 2) * (n + 1) // 2)
    end
end

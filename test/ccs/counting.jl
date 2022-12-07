
@testset "Counting" begin
    
    @testset "E=k x U(x)" begin
        ψ = k -> "E=$k x U(x)"
        for k = 1:10, n = 1:100
            fomc = compute_wfomc_unskolemized(ψ(k), n)
            @test fomc == binomial(BigInt(n), k)
        end
    end

    @testset "E=k x U(x) | V(x)" begin
        ψ = k -> "E=$k x U1(x) | U2(x)"
        for k = 1:10, n = 1:50
            fomc = compute_wfomc_unskolemized(ψ(k), n)
            @test fomc == binomial(BigInt(n), k) * big"3"^k
        end
    end

    @testset "E=k x U(x) | V(x) | W(x)" begin
        ψ = k -> "E=$k x U1(x) | U2(x) | U3(x)"
        for k = 1:5, n = 1:20
            fomc = compute_wfomc_unskolemized(ψ(k), n)
            @test fomc == binomial(BigInt(n), k) * big"7"^k
        end
    end

    @testset "V x E=k y B(x, y)" begin
        ψ = k -> "(V x ~E(x,x)) & (V x V y E(x, y) ==> E(y, x)) & (V x E=$k y E(x, y))"

        # one-regular graphs ... double factorial of (n-1) on even-sized domains
        doublefact = big"1"
        for n in 1:50
            fomc = compute_wfomc_unskolemized(ψ(1), n)
            if n & 1 > 0
                @test fomc == 0
                doublefact *= n
            else
                @test fomc == doublefact
            end
        end
        
        two_regular = [
            0, 0, 1, 3, 12, 70, 465, 3507, 30016, 286884, 3026655, 34944085, 438263364, 5933502822,
            86248951243, 1339751921865, 22148051088480, 388246725873208, 7193423109763089,
            140462355821628771, 2883013994348484940
        ]

        for n in 1:21
            fomc = compute_wfomc_unskolemized(ψ(2), n)
            @test fomc == two_regular[n]
        end


        three_regular = [
            0, 1, 70, 19355, 11180820, 11555272575, 19506631814670, 50262958713792825,
            187747837889699887800, 976273961160363172131825, 6840300875426184026353242750,
            62870315446244013091262178375075, 741227949070136911068308523257857500
        ]

        for i in 1:13
            fomc = compute_wfomc_unskolemized(ψ(3), 2i)
            @test fomc == three_regular[i]
        end
    end

    @testset "E=k x V y B(x, y)" begin
        ψ = k -> "E=$k x V y B(x, y)"
        for k = 1:5, n = 1:20
            fomc = compute_wfomc_unskolemized(ψ(k), n)
            if k > n 
                @test fomc == 0
            else
                @test fomc == binomial(BigInt(n), k) * (big"2"^n - 1)^(n-k)
            end
        end
    end

    @testset "E=k x V y A(x, y) | B(x, y)" begin
        ψ = k -> "E=$k x V y A(x, y) | B(x, y)"
        ϕ = k -> "(E=$k x V y R(x, y)) & (V x V y R(x, y) <=> (A(x, y) | B(x, y)))"
        for k = 1:2, n = 1:5
            @test compute_wfomc_unskolemized(ψ(k), n) == compute_wfomc_unskolemized(ϕ(k), n)
        end
    end

end
    

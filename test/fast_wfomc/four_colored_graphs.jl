ψ = parse_formula(
    "~E(x, x) & " *
    "(~E(x, y) | E(y, x)) & " *
    "(C1(x) | C2(x) | C3(x) | C4(x)) & " *
    "(~C1(x) | ~C2(x)) & " *
    "(~C2(x) | ~C3(x)) & " *
    "(~C1(x) | ~C3(x)) & " *
    "(~C1(x) | ~C4(x)) & " *
    "(~C2(x) | ~C4(x)) & " *
    "(~C3(x) | ~C4(x)) & " *
    "(~E(x,y) | (~(C1(x) & C1(y)) & ~(C2(x) & C2(y)) & ~(C3(x) & C3(y)) & ~(C4(x) & C4(y))))"
)

# Results taken from https://oeis.org/A223887
@testset "$(typeof(algo))" for algo in [NoOptFastWFOMCAlgorithm(), FastWFOMCAlgorithm()]
    @test compute_wfomc(ψ, 0; algo) == 1
    @test compute_wfomc(ψ, 1; algo) == 4
    @test compute_wfomc(ψ, 2; algo) == 28
    @test compute_wfomc(ψ, 3; algo) == 340
    @test compute_wfomc(ψ, 4; algo) == 7108
    @test compute_wfomc(ψ, 5; algo) == 254404
    @test compute_wfomc(ψ, 6; algo) == 15531268
    @test compute_wfomc(ψ, 7; algo) == 1613235460
    @test compute_wfomc(ψ, 8; algo) == 284556079108
    @test compute_wfomc(ψ, 9; algo) == 85107970698244
    @test compute_wfomc(ψ, 10; algo) == 43112647751430148
    @test compute_wfomc(ψ, 11; algo) == 36955277740855136260
    @test compute_wfomc(ψ, 12; algo) == 53562598422461559373828
    @test compute_wfomc(ψ, 13; algo) == 131186989945696839128432644
    @test compute_wfomc(ψ, 14; algo) == 542676256323680030599454982148

    w = WFOMCWeights{fmpz}()
    fill_missing_weights!(w, ψ)
    @test compute_wfomc(ψ, 0, w; algo) == 1
    @test compute_wfomc(ψ, 1, w; algo) == 4
    @test compute_wfomc(ψ, 2, w; algo) == 28
    @test compute_wfomc(ψ, 3, w; algo) == 340
    @test compute_wfomc(ψ, 4, w; algo) == 7108
    @test compute_wfomc(ψ, 5, w; algo) == 254404
    @test compute_wfomc(ψ, 6, w; algo) == 15531268
    @test compute_wfomc(ψ, 7, w; algo) == 1613235460
    @test compute_wfomc(ψ, 8, w; algo) == 284556079108
    @test compute_wfomc(ψ, 9, w; algo) == 85107970698244
    @test compute_wfomc(ψ, 10, w; algo) == 43112647751430148
    @test compute_wfomc(ψ, 11, w; algo) == 36955277740855136260
    @test compute_wfomc(ψ, 12, w; algo) == 53562598422461559373828
    @test compute_wfomc(ψ, 13, w; algo) == 131186989945696839128432644
    @test compute_wfomc(ψ, 14, w; algo) == 542676256323680030599454982148

    w = WFOMCWeights{fmpq}()
    fill_missing_weights!(w, ψ)
    @test compute_wfomc(ψ, 0, w; algo) == 1
    @test compute_wfomc(ψ, 1, w; algo) == 4
    @test compute_wfomc(ψ, 2, w; algo) == 28
    @test compute_wfomc(ψ, 3, w; algo) == 340
    @test compute_wfomc(ψ, 4, w; algo) == 7108
    @test compute_wfomc(ψ, 5, w; algo) == 254404
    @test compute_wfomc(ψ, 6, w; algo) == 15531268
    @test compute_wfomc(ψ, 7, w; algo) == 1613235460
    @test compute_wfomc(ψ, 8, w; algo) == 284556079108
    @test compute_wfomc(ψ, 9, w; algo) == 85107970698244
    @test compute_wfomc(ψ, 10, w; algo) == 43112647751430148
    @test compute_wfomc(ψ, 11, w; algo) == 36955277740855136260
    @test compute_wfomc(ψ, 12, w; algo) == 53562598422461559373828
    @test compute_wfomc(ψ, 13, w; algo) == 131186989945696839128432644
    @test compute_wfomc(ψ, 14, w; algo) == 542676256323680030599454982148

    w = WFOMCWeights{Complex{BigInt}}()
    fill_missing_weights!(w, ψ)
    @test compute_wfomc(ψ, 0, w; algo) == 1
    @test compute_wfomc(ψ, 1, w; algo) == 4
    @test compute_wfomc(ψ, 2, w; algo) == 28
    @test compute_wfomc(ψ, 3, w; algo) == 340
    @test compute_wfomc(ψ, 4, w; algo) == 7108
    @test compute_wfomc(ψ, 5, w; algo) == 254404
    @test compute_wfomc(ψ, 6, w; algo) == 15531268
    @test compute_wfomc(ψ, 7, w; algo) == 1613235460
    @test compute_wfomc(ψ, 8, w; algo) == 284556079108
    @test compute_wfomc(ψ, 9, w; algo) == 85107970698244
    @test compute_wfomc(ψ, 10, w; algo) == 43112647751430148
    @test compute_wfomc(ψ, 11, w; algo) == 36955277740855136260
    @test compute_wfomc(ψ, 12, w; algo) == 53562598422461559373828
    @test compute_wfomc(ψ, 13, w; algo) == 131186989945696839128432644
    @test compute_wfomc(ψ, 14, w; algo) == 542676256323680030599454982148

    w = WFOMCWeights{Complex{Rational{BigInt}}}()
    fill_missing_weights!(w, ψ)
    @test compute_wfomc(ψ, 0, w; algo) == 1
    @test compute_wfomc(ψ, 1, w; algo) == 4
    @test compute_wfomc(ψ, 2, w; algo) == 28
    @test compute_wfomc(ψ, 3, w; algo) == 340
    @test compute_wfomc(ψ, 4, w; algo) == 7108
    @test compute_wfomc(ψ, 5, w; algo) == 254404
    @test compute_wfomc(ψ, 6, w; algo) == 15531268
    @test compute_wfomc(ψ, 7, w; algo) == 1613235460
    @test compute_wfomc(ψ, 8, w; algo) == 284556079108
    @test compute_wfomc(ψ, 9, w; algo) == 85107970698244
    @test compute_wfomc(ψ, 10, w; algo) == 43112647751430148
    @test compute_wfomc(ψ, 11, w; algo) == 36955277740855136260
    @test compute_wfomc(ψ, 12, w; algo) == 53562598422461559373828
    @test compute_wfomc(ψ, 13, w; algo) == 131186989945696839128432644
    @test compute_wfomc(ψ, 14, w; algo) == 542676256323680030599454982148
end

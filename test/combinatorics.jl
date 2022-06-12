import FastWFOMC: PascalTriangle

@testset "Pascal Triangle" begin
    pt = PascalTriangle(500)

    for i = 0:200
        for j = 0:i
            @test binomial(big(i), j) == pt[i, j]
        end
    end

end

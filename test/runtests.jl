using Test
using FastWFOMC
using Nemo

@testset "FastWFOMC Tests" begin
    @testset "AIMA logic" begin
        include("aimalogic.jl")
    end

    @testset "Combinatorics" begin
        include("combinatorics.jl")
    end

    @testset "Fast WFOMC" begin
        @testset "Number of undirected graphs" begin
            include("fast_wfomc/undirected_graphs.jl")
        end
    
        @testset "Number of 4-colored graphs" begin
            include("fast_wfomc/four_colored_graphs.jl")
        end
    
        @testset "Number of connected undirected graphs" begin
            include("fast_wfomc/undirected_connected_graphs.jl")
        end

        @testset "Miscellaneous" begin
            include("fast_wfomc/misc.jl")
        end
    end

    @testset "WFOMC with CCs" begin
        # @testset "Number of three-regular graphs" begin
        #     include("ccs/three_regular_graphs.jl")
        # end
        include("ccs/counting.jl")
    end
end

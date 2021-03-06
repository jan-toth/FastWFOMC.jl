module FastWFOMC

using LightGraphs
using Nemo

import LinearAlgebra

include("utils/utils.jl")
using .utils

export compute_wfomc, WFOMCWeights, CardinalityConstraint
export NoOptFastWFOMCAlgorithm, FastWFOMCAlgorithm
export fill_missing_weights!
export Formula, parse_formula

include("logic/logic.jl")
include("types/types.jl")
include("cells.jl")
include("wmc.jl")
include("algorithm.jl")

end # module

module FastWFOMC

using LightGraphs
using MultivariatePolynomials, Nemo

import LinearAlgebra
import MultivariatePolynomials as MP

include("utils/utils.jl")
using .utils

export compute_wfomc, WFOMCWeights, CardinalityConstraint
export NoOptFastWFOMCAlgorithm, FastWFOMCAlgorithm, LinearOrderWFOMCAlgorithm
export fill_missing_weights!
export expr, Expression

include("logic/logic.jl")
include("types/types.jl")
include("cells.jl")
include("algorithms/algorithms.jl")

end # module

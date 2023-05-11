"""All algorithms for WFOMC should subtype this."""
abstract type WFOMCAlgorithm end



"""
    compute_wfomc(ψ::Formula, domainsize::Integer [, weights::WFOMCWeights]; kwargs...)

Compute weighted first order model count (WFOMC).

If `weights` are not provided, they are all set to `1`.
`kwargs` may specify special predicates or change the computation's behavior in some way:
1. `algo` - algorithm to be used.
2. `ccs` - list of cardinality constraints for some of the predicates in the formula `ψ`.
"""
function compute_wfomc(ψ::Formula, domainsize::Integer, weights::WFOMCWeights; kwargs...)
    wfomc = WFOMC(ψ, domainsize, weights)

    algo = get(kwargs, :algo, FastWFOMCAlgorithm())
    ccs = get(kwargs, :ccs, CardinalityConstraint[])

    if isempty(ccs)
        compute_wfomc(wfomc, algo)
    else
        compute_wfomc_ccs(WFOMC(ψ, domainsize, weights), ccs, algo)
    end
end


function compute_wfomc(ψ::Formula, domainsize::Integer; kwargs...)
    # weights = WFOMCWeights{Rational{BigInt}}()
    weights = WFOMCWeights()

    fill_missing_weights!(weights, ψ)
    compute_wfomc(ψ, domainsize, weights; kwargs...)
end


function compute_wfomc(::WFOMC, algo::WFOMCAlgorithm)
    ArgumentError("Unsupported algorithm '$(algo)'") |> throw
end


function compute_wfomc_ccs(::WFOMC, ccs::Vector{CardinalityConstraint}, algo::WFOMCAlgorithm)
    ArgumentError("Unsupported algorithm '$(algo)' for WFOMC with cardinality constraints.") |> throw
end


include("fast_wfomc.jl")
include("ccs.jl")
include("linear_order.jl")
include("wmc.jl")

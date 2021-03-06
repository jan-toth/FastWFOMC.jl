"""
    WFOMC{T<:WFOMCWeightsType}

All information necessary for computing the Weighted First Order Model Count.
"""
struct WFOMC{T<:WFOMCWeightsType}
    ψ::Expression
    domainsize::Int
    weights::WFOMCWeights{T}

    function WFOMC(ψ::Expression, domsize::Integer, weights::WFOMCWeights{T}) where {T<:WFOMCWeightsType}
        domsize < 0 && throw(DomainError("Domain size must be non-negative! It was $domsize."))
        _check_weights(weights, ψ) || throw(ArgumentError("Some predicates have unset weights!"))

        return new{T}(ψ, domsize, weights)
    end
end

# Accessors for WFOMC objects.
formula(wfomc::WFOMC) = wfomc.ψ
domsize(wfomc::WFOMC) = wfomc.domainsize
weights(wfomc::WFOMC) = wfomc.weights

function WFOMC{T}(ψ::Expression, domsize::Integer, weights::WFOMCWeights{U}) where {T<:WFOMCWeightsType,U<:WFOMCWeightsType}
    return WFOMC(ψ, domsize, WFOMCWeights{T}(weights))
end

function WFOMC{T}(ψ::Expression, domsize::Integer) where {T<:WFOMCWeightsType}
    weights = WFOMCWeights{T}()
    fill_missing_weights!(weights, ψ)
    return WFOMC(ψ, domsize, weights)
end

function WFOMC(ψ::Expression, domsize::Integer)
    weights = WFOMCWeights{Rational{BigInt}}()
    fill_missing_weights!(weights, ψ)
    return WFOMC(ψ, domsize, weights)
end

function WFOMC(wfomc::WFOMC{T}, weights::WFOMCWeights{T}) where {T<:WFOMCWeightsType}
    WFOMC(formula(wfomc), domsize(wfomc), weights)
end


Base.zero(wfomc::WFOMC) = zero(weights(wfomc))
Base.zeros(wfomc::WFOMC, dims...) = zeros(weights(wfomc), dims...)

Base.one(wfomc::WFOMC) = one(weights(wfomc))
Base.ones(wfomc::WFOMC, dims...) = ones(weights(wfomc), dims...)

function _check_weights(weights::WFOMCWeights{T}, ψ::Expression) where {T}
    for (symbol, _) in predicate_symbols(ψ)
        if !haskey(weights, symbol)
            @warn "Weights unset for symbol \"$symbol\"."
            return false
        end
    end

    return true
end




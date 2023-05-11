function compute_wfomc_ccs(wfomc::WFOMC{T}, ccs::Vector{CardinalityConstraint}, algo::WFOMCAlgorithm) where {T <: Union{Number, fmpz, fmpq}}
    ring, vars = PolynomialRing(QQ, length(ccs))
    exponents = zeros(Int, nvars(ring))

    w⁺ = WFOMCWeights{fmpq_mpoly}()
    for (pred, (w, w̄)) in weights(wfomc)
        w⁺[pred] = PredicateWeights(ring(w), ring(w̄))
    end

    for (i, (xᵢ, cc)) in enumerate(zip(vars, ccs))
        w⁺[cc.pred] = PredicateWeights(xᵢ, one(ring))
        exponents[i] = cc.k
    end

    wmc_poly = compute_wfomc(WFOMC(formula(wfomc), domsize(wfomc), w⁺), algo)
    @assert isone(denominator(wmc_poly))
    wmc_poly = numerator(wmc_poly)

    return coeff(wmc_poly, vars, exponents)
end


function compute_wfomc_ccs(wfomc::WFOMC{T}, ccs::Vector{CardinalityConstraint}, algo::WFOMCAlgorithm) where {T <: MP.AbstractPolynomialLike}
    error("TODO. Not implemented yet.")
end 


function compute_wfomc_ccs(wfomc::WFOMC{T}, ccs::Vector{CardinalityConstraint}, algo::WFOMCAlgorithm) where {T <: _NemoPolynomial}
    error("TODO. Not implemented yet. ... ?? Nemo.jl weights ??")
    oldring = _ring(weights(wfomc))
# #     M = Dict(pred[1] => domsize(wfomc)^pred[2] for pred in predicate_symbols(formula(wfomc)))

# #     m = length(wfomc.ccs)
# #     n = nvars(oldring)

# #     newring, vars = PolynomialRing(QQ, m + n)
# #     mapping = Dict(i => i + m for i = 1:n)

# #     exponents = zeros(Int, m)

# #     w⁺ = WFOMCWeights{fmpq_mpoly}()
# #     for (pred, (w, w̄)) in weights(wfomc)
# #         new_w = changering(w, newring; mapping)
# #         new_w̄ = changering(w̄, newring; mapping)
# #         w⁺[pred] = PredicateWeights(new_w, new_w̄)
# #     end

# #     for (i, (xᵢ, cc)) in enumerate(zip(vars, constraints(wfomc)))
# #         w⁺[cc.pred] = PredicateWeights(xᵢ, one(newring))
# #         exponents[i] = cc.k
# #     end

# #     wmc_poly = _compute_wfomc_internal(formula(wfomc), domsize(wfomc), w⁺)

# #     denom = denominator(wmc_poly)
# #     @assert isconstant(denom)

# #     A = coeff(numerator(wmc_poly), gens(newring)[1:m], exponents)

# #     mapping = Dict(i => 1 for i = 1:m)  # all generators 1:m will have zero power ... just get rid of them
# #     for i = (m+1):nvars(newring)
# #         mapping[i] = i - m
# #     end

# #     A = changering(A, oldring; mapping)

# #     for cc in constraints(wfomc)
# #         w, w̄ = weights(wfomc)[cc.pred]
# #         A *= w^cc.k * w̄^(M[cc.pred] - cc.k)
# #     end

# #     return A / changering(denom, oldring; mapping)
end

# """Assumes enough variables."""
# function changering(poly, newring; mapping = nothing)
#     oldring = parent(poly)
#     isnothing(mapping) && (mapping = Dict(i => i for i = 1:nvars(oldring)))

#     res = zero(newring)
#     for oldterm in terms(poly)
#         newterm = newring(leading_coefficient(oldterm))

#         old_exponents = exponent_vector(oldterm, 1)

#         new_exponents = zeros(Int, nvars(newring))
#         for (i, exp) in enumerate(old_exponents)
#             new_exponents[mapping[i]] += exp
#         end

#         set_exponent_vector!(newterm, 1, new_exponents)
#         res += newterm
#     end

#     return res
# end

# function changering(poly::PolyElem, newring::MPolyRing; mapping = nothing)
#     if isnothing(mapping)
#         mapping = 1
#     elseif isa(mapping, Dict)
#         mapping = first(mapping).second
#     end

#     res = zero(newring)

#     for i = 0:Nemo.degree(poly)
#         a = coeff(poly, i)
#         iszero(a) && continue

#         newterm = newring(a)
#         exps = zeros(Int, nvars(newring))
#         exps[mapping] = i

#         set_exponent_vector!(newterm, 1, exps)
#         res += newterm
#     end

#     return res
# end

# function changering(poly::PolyElem, newring::PolyRing)
#     new_base = newring.base_ring

#     res = zero(newring)
#     for i = 0:Nemo.degree(poly)
#         old_coeff = coeff(poly, i)
#         setcoeff!(res, i, new_base(old_coeff))
#     end

#     return res
# end

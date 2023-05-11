# ====================================================================================
# UTILS for Linear System of Equations to solve WFOMC with CCs
# ====================================================================================

function build_system(wfomc::WFOMCWithCC)
    arities = Dict(symbol => arity for (symbol, arity) in predicate_symbols(wfomc.ψ))
    M = [domsize(wfomc)^arities[predicate(cc)] for cc in constraints(wfomc)]
    return _build_system(wfomc, M)
end

function _build_system(wfomc::WFOMCWithCC, M)
    n = prod(M .+ 1)

    w⁺ = copy(weights(wfomc))

    A = zeros(w⁺, n, n)
    b = ones(w⁺, n)

    points = enumerate(Iterators.product(ntuple(i -> 0:M[i], length(M))...))

    A[:, 1] = b
    for (c, degs) in Iterators.drop(points, 1)
        for (r, vals) in points
            A[r, c] = prod(vals .^ degs)
        end
    end


    for (i, vals) in points
        for (cc, val) in zip(constraints(wfomc), vals)
            w⁺[predicate(cc)] = val
        end

        rhs = WFOMC(formula(wfomc), domsize(wfomc), w⁺)
        b[i] = compute_wfomc(rhs, FastWFOMCAlgorithm())
    end

    return A, b
end

"""n is the vector of "count-statistics". It is the input ofthe WMC function."""
function get_coeff_index(M, n...)
    acc = 1
    index = 1
    for (d, maxdeg) in zip(n, M)
        index += d * acc
        acc *= maxdeg
    end
    return index
end


_exactdiv(a, b) = a / b
_exactdiv(a::Integer, b::Integer) = div(a, b)

function det_bareiss!(M)
    n = size(M, 1)
    sign, prev = Int8(1), one(eltype(M))
    for i = 1:n-1
        if iszero(M[i, i]) # swap with another col to make nonzero
            swapto = findfirst(!iszero, @view M[i, i+1:end])
            isnothing(swapto) && return zero(prev)
            sign = -sign
            Base.swapcols!(M, i, i + swapto)
        end
        for k = i+1:n, j = i+1:n
            M[j, k] = _exactdiv(M[j, k] * M[i, i] - M[j, i] * M[i, k], prev)
        end
        prev = M[i, i]
    end
    return sign * M[end, end]
end


function solve_system(A, b, index)
    denom = det_bareiss!(copy(A))

    A[:, index] = b
    nom = det_bareiss!(A)
    return nom / denom
end



"""
Univariate Langrangian interpolation for Nemo polynomials.

Enable Lagrange interpolation for rational polynomials by removing the call to reducing polynomial length.
Ergo, the resulting polynomial will have n coefficients (for n points given) even though some of the highest order coeffs might be zero.
"""
# import AbstractAlgebra
function AbstractAlgebra.interpolate(S::FmpqPolyRing, x::Vector{fmpq}, y::Vector{fmpq})
    length(x) != length(y) && error("Array lengths don't match in interpolate")
    n = length(x)
    if n == 0
        return S()
    elseif n == 1
        return S(y[1])
    end
    R = base_ring(S)
    parent(y[1]) != R && error("Polynomial ring does not match inputs")
    P = Array{fmpq}(undef, n)
    for i = 1:n
        P[i] = deepcopy(y[i])
    end
    for i = 2:n
        t = P[i-1]
        for j = i:n
            p = P[j] - t
            q = x[j] - x[j-i+1]
            t = P[j]
            P[j] = p * inv(q) # must have invertible q for now
        end
    end
    newton_to_monomial!(P, x)
    r = S(P)
    return r
end

using Nemo
R = QQ
S, x = PolynomialRing(R, "x")

xs = R.([0, 1 // 2, 1, 5 // 4])
ys = R.([1, 0, 0, 11 // 10])
interpolate(S, xs, ys)

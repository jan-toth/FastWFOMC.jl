"""Algorithm for WFOMC computation enforcing linear ordering on the domain."""
struct LinearOrderWFOMCAlgorithm <: WFOMCAlgorithm end


function compute_wfomc(wfomc::WFOMC, ::LinearOrderWFOMCAlgorithm)
    ψ = formula(wfomc) # & Formula("LEQ", Variable("x"), Variable("x"))
    
    cells = build_valid_cells(ψ)
    w = compute_cell_weights(weights(wfomc), cells)
    R = _compute_cell_interactions_lo(ψ, weights(wfomc), cells)
    
    table = Dict(Int[k == i for k in 1:length(cells)] => w[i] for (i, wᵢ) in enumerate(w))
    for _ in 2:domsize(wfomc)
        oldtable = table
        table = Dict()

        for (j, wⱼ) in enumerate(w)
            for (ivec, w_old) in oldtable
                w_new = w_old * wⱼ * prod(R[k, j]^ivec[k] for k in 1:length(cells))
                
                ivec = ivec[:]
                ivec[j] += 1

                w_new = get!(table, ivec, 0) + w_new
                table[ivec] = w_new
            end
        end
    end

    t = table |> values |> sum
    nfact = domsize(wfomc) |> big |> factorial
    return  nfact * t
end



function compute_wfomc_ccs(wfomc::WFOMC, ccs::Vector{CardinalityConstraint}, ::LinearOrderWFOMCAlgorithm)
    error("TODO: Not implemented yet.")
end


function _compute_cell_interactions_lo(ψ::Formula, weights::WFOMCWeights, cells)
    xcells_cache = [convert(Formula, cell) for cell in cells]
    substitution = Dict(Variable("x") => Variable("y"))

    condition_props = proposition_symbols(xcells_cache[1])
    condition_props = union!(condition_props, [Formula(prop.operator, ntuple(i -> Variable("y"), length(prop.arguments))) for prop in condition_props])
    condition_props = union!(condition_props, [Formula("LEQ", Variable("y"), Variable("x")), Formula("LEQ", Variable("x"), Variable("y"))])

    R = zeros(weights, length(cells), length(cells))
    φ = ψ & substitute(Dict(Formula("x") => Formula("y"), Formula("y") => Formula("x")), ψ)
    φ = φ & Formula("LEQ", Variable("y"), Variable("x")) & ~Formula("LEQ", Variable("x"), Variable("y"))
    for i in 1:length(cells)
        cellY = substitute(substitution, xcells_cache[i])
        ψᵢ = φ & cellY

        for j = 1:length(cells)
            cellX = xcells_cache[j]
            ψᵢⱼ = ψᵢ & cellX
            R[j, i] = wmc(ψᵢⱼ, weights; evidence = condition_props)
        end
    end

    return R
end

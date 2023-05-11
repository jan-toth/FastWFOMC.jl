"""Algorithm for WFOMC computation that sets I₁ = I₂ = ∅."""
struct NoOptFastWFOMCAlgorithm <: WFOMCAlgorithm end

"""Algorithm for WFOMC computation using all optimizations."""
struct FastWFOMCAlgorithm <: WFOMCAlgorithm end


function compute_wfomc(wfomc::WFOMC, ::NoOptFastWFOMCAlgorithm)
    cell_graph = build_cell_graph(formula(wfomc), weights(wfomc))
    ncells = length(cell_graph.cells)
    ncells > 0 || return zero(wfomc)

    R, w = cell_graph.R, cell_graph.w

    result = zero(wfomc)
    for partitions in Iterators.map(x -> big.(x), mymultiexponents(domsize(wfomc), ncells))
        term = mymultinomial(partitions...)

        for j = 1:ncells
            for i = 1:j-1
                term *= R[i, j]^(partitions[i] * partitions[j])

            end
            term *= R[j, j]^binomial(partitions[j], 2) * w[j]^partitions[j]
        end

        result += term
    end

    return result
end


function compute_wfomc(wfomc::WFOMC, ::FastWFOMCAlgorithm)
    empty!(CACHE)
    pt = PascalTriangle(domsize(wfomc))

    collapsed_graph = build_collapsed_cell_graph(formula(wfomc), weights(wfomc))
    ncliques = length(collapsed_graph.cliques)

    g = Graph(ncliques)
    for i = 1:ncliques
        for j = (i+1):ncliques
            collapsed_graph.R[j, i] == 1 || add_edge!(g, i, j)
        end
    end

    loops = Set{Int}()
    for (clique_idx, clique) in enumerate(collapsed_graph.cliques)
        for n = 0:domsize(wfomc)
            if _jterm(clique, n; clique_idx, pt) != 1
                push!(loops, clique_idx)
                break
            end
        end
    end

    # nonind are vertices neither in I₁ nor in I₂
    I₁ = Set(independent_set(g, MaximalIndependentSet()))
    nonind = setdiff(Set(vertices(g)), I₁)

    I₂ = intersect(I₁, loops)
    setdiff!(I₁, I₂)  # compute I₁

    independent_cell_graph = (I₁ = collect(I₁), I₂ = collect(I₂), nonind = collect(nonind), nonind_ordering = Dict(j => i for (i, j) in enumerate(nonind)))

    result = _run_optimized_loop(wfomc, collapsed_graph, independent_cell_graph; pt)

    @debug "Cache status" Cache=CACHE
    
    return result
end


function _run_optimized_loop(wfomc::WFOMC, ccg, icg; pt = nothing)
    ncliques = length(ccg.cliques)

   @debug "IndependentCellGraph" icg=icg

    result = zero(wfomc)
    for partitions in Iterators.map(x -> big.(x), mymultiexponents(domsize(wfomc), length(icg.nonind) + 1))
        # partitions[end] is the number N assigned to I₁ and I₂
        coefficient = mymultinomial(pt, partitions...)

        body = one(wfomc)
        for i = 1:ncliques
            for j = (i+1):ncliques
                if i ∈ icg.nonind && j ∈ icg.nonind
                    power = partitions[icg.nonind_ordering[i]] * partitions[icg.nonind_ordering[j]]
                    body *= ccg.R[j, i]^power
                end
            end
        end

        for clique_idx in icg.nonind
            clique = ccg.cliques[clique_idx]
            nᵢ = partitions[icg.nonind_ordering[clique_idx]]
            body *= _jterm(clique, nᵢ; clique_idx, pt)
            body *= clique.w^nᵢ
        end

        result += coefficient * body * _gterm(length(icg.I₂), 0, @view partitions[1:end-1]; domsize=domsize(wfomc), ccg, icg, pt)
    end
    return result
end


function _jterm(clique, n̂; clique_idx = objectid(clique), pt::Union{Nothing,PascalTriangle} = nothing)
    key = (clique_idx, n̂)
    return get!(CACHE.jterm, key) do
        length(clique.indices) == 1 && return clique.s^mybinomial(pt, n̂, 2)
        return clique.r^mybinomial(pt, n̂, 2) * _dterm(clique, 1, n̂; clique_idx, pt)
    end
end


function _dterm(clique, i, n̂; clique_idx = objectid(clique), pt::Union{Nothing,PascalTriangle} = nothing)
    key = (clique_idx, i, n̂)
    return get!(CACHE.dterm, key) do
        i == length(clique.indices) && return (clique.s / clique.r)^mybinomial(pt, n̂, 2)

        term = zero(clique.w)
        for nᵢ in 0:n̂
            m = mybinomial(pt, n̂, nᵢ) * (clique.s / clique.r)^mybinomial(pt, nᵢ, 2)
            m *= _dterm(clique, i + 1, n̂ - nᵢ; clique_idx, pt)
            term += m
        end

        return term
    end
end


function _gterm(p, N, partitions; domsize, ccg, icg, pt = nothing)
    g = zero(ccg.cliques[1].w)

    if p == 0
        for i in icg.I₁
            clique_I₁ = ccg.cliques[i]

            term = clique_I₁.w
            for j in icg.nonind
                jpos = icg.nonind_ordering[j]
                term *= ccg.R[j, i]^partitions[jpos]
            end
            g += term
        end
        return g^(domsize - N - sum(partitions))
    else
        clique_idx = icg.I₂[end - p + 1]
        clique_I₂ = ccg.cliques[clique_idx]

        vals = 0:(domsize-N-sum(partitions))
        for nₖ₊ₚ in vals 
            term = mybinomial(pt, vals.stop, nₖ₊ₚ)
            term *= clique_I₂.w^nₖ₊ₚ
            term *= _jterm(clique_I₂, nₖ₊ₚ; clique_idx, pt)
            
            for j in icg.nonind
                jpos = icg.nonind_ordering[j]
                # println(j, " ", clique_idx)
                term *= ccg.R[j, clique_idx]^(partitions[jpos] * nₖ₊ₚ)
            end

            term *= _gterm(p - 1, N + nₖ₊ₚ, partitions; domsize, ccg, icg, pt)
            g += term
        end
        return g
    end
end
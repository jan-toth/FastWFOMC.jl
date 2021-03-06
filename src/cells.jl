"""
    Cell

A maximally consistent conjunction of unary and binary reflexive predicates.
"""
struct Cell
    interpretation::BitVector
    atoms::Vector{Formula}

    function Cell(interpretation::BitVector, atoms::Vector{Formula})
        length(interpretation) == length(atoms) || throw(ArgumentError("The lifted interpretation and the atom list must be of the same length."))
        new(interpretation, atoms)
    end
end

Cell(interpretation::Vector{Integer}, atoms::Vector{Formula}) = Cell(convert(BitVector, interpretation), atoms)

Base.convert(::Type{Cell}, cell::Cell) = cell
Base.convert(::Type{Formula}, cell::Cell) = reduce(&, _generate_literals(cell))
Base.promote_rule(::Type{Formula}, ::Type{Cell}) = Formula
Base.show(io::IO, cell::Cell) = print(io, join(_generate_literals(cell), " ∧ "))

Base.:&(lhs::Formula, rhs::Cell) = Formula("&", lhs, convert(Formula, rhs))
Base.:&(lhs::Cell, rhs::Formula) = Formula("&", convert(Formula, lhs), rhs)

function _generate_literals(cell::Cell)
    return (truthvalue ? atom : ~atom for (truthvalue, atom) in zip(cell.interpretation, cell.atoms))
end

"""
    build_cells(ψ::Formula)

Naively build all cells of the formula `ψ` for variable `x`.

If there are `p` distict predicate symbols in `ψ`, there are `2ᵖ` cells.
"""
function build_cells(ψ::Formula)
    atoms = substitute(Dict(Variable("y") => Variable("x")), ψ) |> proposition_symbols |> collect
    p = length(atoms)

    n = 2^p
    cells = Vector{Cell}(undef, n)
    
    for (i, rank) in enumerate(0:n-1)
        interpretation = BitVector(undef, p)
        for j in 1:p
            interpretation[j] = (rank & (1 << (j - 1))) > 0
        end

        cells[i] = Cell(interpretation, atoms)
    end

    return cells
end


"""
    build_valid_cells(ψ::Formula)

Build valid cells (1-types) of the formula `ψ` for variable `x`.

If there are `p` distict predicate symbols in `ψ`, there are `2ᵖ` cells in total.
However, conditioning `ψ` on some cells may lead to an unsatisfiable formula.
This function builds cells that are guaranteed to lead to a satisfiable residual formula,
i.e., *valid* cells.
"""
function build_valid_cells(ψ::Formula)
    ψ = substitute(Dict(Variable("y") => Variable("x")), ψ)

    atoms = proposition_symbols(ψ) |> collect
    p = length(atoms)

    models = find_all_models(ψ)
    cells = Vector{Cell}(undef, length(models))

    for (i, model) in enumerate(models)
        interpretation = BitVector(undef, p)
        for j in 1:p
            interpretation[j] = model[atoms[j]]
        end

        cells[i] = Cell(interpretation, atoms)
    end

    return cells
end

"""
    build_cell_graph(ψ::Formula, weights::WFOMCWeights{T})

Build the cell graph for the formula `ψ`.

The cell graph is represented as a named tuple containing:
1. `cells` - list of valid cells that represent the graph nodes
2. `R` - symmetric matrix holding `sₖ`'s on the diagonal and `rᵢⱼ`'s off-diagonal
3. `w` - vector holding `wₖ` values
"""
function build_cell_graph(ψ::Formula, weights::WFOMCWeights)
    cells = build_valid_cells(ψ)

    w = compute_cell_weights(weights, cells)
    R = compute_cell_interactions(ψ, weights, cells)
    
    return (cells=cells, R, w)
end

function compute_cell_weights(weights::WFOMCWeights, cells)
    w = zeros(weights, length(cells))
    for (k, cell) in enumerate(cells)
        wmc = one(weights)
        for (symbol, value) in zip(cell.atoms, cell.interpretation)
            wmc *= weights[symbol.operator][value ? 1 : 2]
        end
        w[k] = wmc
    end

    return w
end

function compute_cell_interactions(ψ::Formula, weights::WFOMCWeights, cells)
    xcells_cache = [convert(Formula, cell) for cell in cells]
    substitution = Dict(Variable("x") => Variable("y"))

    condition_props = proposition_symbols(xcells_cache[1])
    condition_props = union!(condition_props, [Formula(prop.operator, ntuple(i -> Variable("y"), length(prop.arguments))) for prop in condition_props])
    ncells = length(cells)

    R = zeros(weights, ncells, ncells)
    φ = ψ & substitute(Dict(Formula("x") => Formula("y"), Formula("y") => Formula("x")), ψ) 
    for i in 1:ncells
        cellY = substitute(substitution, xcells_cache[i])
        ψᵢ = φ & cellY

        for j = i:ncells
            cellX = xcells_cache[j]
            ψᵢⱼ = ψᵢ & cellX
            R[j, i] = wmc(ψᵢⱼ, weights; evidence = condition_props)
        end
    end

    return Symmetric(R, 'L')
end

"""
    find_symmetric_cliques(cell_graph)

Given a cell graph of a formula, partition the cells into sets of symmetric cells, i.e., symmetric cliques.

Cells of a symmetric clique interact in the same way not only with each other, but also
with the cells outside of the clique.

Each clique is represented as a named tuple with
1. `indices` - list of indices of cells (of the source cell graph) that make up the clique
2. `w` - the clique's `wₖ` weight
3. `s` - the clique's `sₖ` weight
4. `r` - the clique's `rᵢⱼ` weight; if `length(indices) == 1`, it is set to `1`

See also: [`build_cell_graph`](@ref)

# Arguments
`cell_graph` - a named tuple containing
1. `cells` - list of valid cells that represent the graph nodes
2. `R` - symmetric matrix holding `sₖ`'s on the diagonal and `rᵢⱼ`'s off-diagonal
3. `w` - vector holding `wₖ` values
"""
function find_symmetric_cliques(cell_graph)
    cliques = Vector()

    cell_indices = Set(eachindex(cell_graph.cells))
    while length(cell_indices) > 0
        cell_idx = pop!(cell_indices)
        clique = (indices=Set([cell_idx]), w=cell_graph.w[cell_idx], s=cell_graph.R[cell_idx, cell_idx], r=one(cell_graph.w[cell_idx]))

        for cell_idx in cell_indices
            if _is_clique_compatible(cell_idx, clique, cell_graph)
                push!(clique.indices, cell_idx)
            end
        end

        setdiff!(cell_indices, clique.indices)
        if length(clique.indices) > 1
            clique = (clique.indices, clique.w, clique.s, r=cell_graph.R[first(clique.indices, 2)...])
        end

        push!(cliques, clique)
    end

    return cliques
end

function _is_clique_compatible(cell_idx, clique, cell_graph)
    isequal(cell_graph.w[cell_idx], clique.w) || return false
    isequal(cell_graph.R[cell_idx, cell_idx], clique.s) || return false

    for c in eachindex(cell_graph.cells)
        c == cell_idx && continue
        c ∈ clique.indices && continue
        isequal(cell_graph.R[cell_idx, c], cell_graph.R[first(clique.indices), c]) || return false
    end

    if length(clique.indices) > 1
        clique_r = cell_graph.R[first(clique.indices, 2)...]
        for c in clique.indices
            isequal(cell_graph.R[cell_idx, c], clique_r) || return false
        end
    end

    return true
end


"""
    build_collapsed_cell_graph(ψ::Formula, weights::WFOMCWeights)

Build a cell graph of a formula `ψ`, with nodes being the symmetric cliques of valid cells on `ψ`.

The collapsed graph is a tuple of
1. `cells` - list of (nodes) valid cells of the given cell graph
2. `cliques` - list of symmetric cliques
3. `R` - weighted interactions among the cliques

Each node (clique) of the collapsed cell graph consists of
1. `indices` - list of indices of cells (of the source cell graph) that make up the clique
2. `w` - the clique's `wₖ` weight
3. `s` - the clique's `sₖ` weight
4. `r` - the clique's `rᵢⱼ` weight; if `length(indices) == 1`, it is set to `1`

See also: [`build_cell_graph`](@ref), [`find_symmetric_cliques`](@ref)
"""
function build_collapsed_cell_graph(ψ::Formula, weights::WFOMCWeights)
    cell_graph = build_cell_graph(ψ, weights)
    return collapse_cell_graph(cell_graph)
end

"""
    collapse_cell_graph(cell_graph)

Given a cell graph, find its symmetric cliques and collapse them into new nodes.

The collapsed graph is a tuple of
1. `cells` - list of (nodes) valid cells of the given cell graph
2. `cliques` - list of symmetric cliques
3. `R` - weighted interactions among the cliques (values on the diagonal are to be ignored, see `clique.s` and `clique.r` for interactions inside a clique)

Each node (clique) of the collapsed cell graph consists of
1. `indices` - list of indices of cells (of the source cell graph) that make up the clique
2. `w` - the clique's `wₖ` weight
3. `s` - the clique's `sₖ` weight
4. `r` - the clique's `rᵢⱼ` weight; if `length(indices) == 1`, it is set to `1`

See also: [`build_collapsed_cell_graph`](@ref), [`find_symmetric_cliques`](@ref)

# Arguments
`cell_graph` - a named tuple containing
1. `cells` - list of valid cells that represent the graph nodes
2. `R` - symmetric matrix holding `sₖ`'s on the diagonal and `rᵢⱼ`'s off-diagonal
3. `w` - vector holding `wₖ` values
"""
function collapse_cell_graph(cell_graph)
    cliques = find_symmetric_cliques(cell_graph)

    ncliques = length(cliques)
    R = fill(zero(cliques[1].s), ncliques, ncliques)

    for (i, clique) in enumerate(cliques)
        u = first(clique.indices)
        for j in (i+1):ncliques
            v = first(cliques[j].indices)
            R[j, i] = cell_graph.R[u, v]
        end
    end

    R = Symmetric(R, 'L')
    return (cells=cell_graph.cells, cliques, R)
end

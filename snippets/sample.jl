using Pkg

# Use current folder as a Julia project
Pkg.activate(".")

# Add FastWFOMC.jl dependency to the current Julia project
Pkg.add(PackageSpec(url="https://github.com/jan-toth/FastWFOMC.jl"))

# Install all dependencies that might be missing
Pkg.instantiate()





using FastWFOMC

cell_graph = get_cell_graph("(~B0(x, y) | S0(x))")
println(cell_graph)

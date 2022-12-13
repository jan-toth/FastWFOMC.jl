# using Pkg

# # Use current folder as a Julia project
# Pkg.activate("."; io=devnull)

# # Add FastWFOMC.jl dependency to the current Julia project
# Pkg.add(PackageSpec(url="https://github.com/jan-toth/FastWFOMC.jl"))

# # Install all dependencies that might be missing
# Pkg.instantiate()

# using FastWFOMC

# open(ARGS[1]) do fr
#     for line in readlines(fr)
#         startswith(line, '#') && continue
#         cell_graph = get_cell_graph(line)
#         println(cell_graph)
#     end
# end




# Command to run Julia with the new sysimage
# $ julia --sysimage "bin/FWFOMC_$(VERSION).so"

using .FastWFOMC

# "~B0(x, y) | S0(x)"
sentence = ARGS[1]
cell_graph = get_cell_graph(sentence)
println(cell_graph)

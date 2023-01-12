using Pkg
using Base.Threads

# # Use current folder as a Julia project
Pkg.activate("."; io=devnull)

# # Add FastWFOMC.jl dependency to the current Julia project
# Pkg.add(PackageSpec(url="https://github.com/jan-toth/FastWFOMC.jl"))

# # Install all dependencies that might be missing
# Pkg.instantiate()

using FastWFOMC

function process_sentences(file=ARGS[1], limit_sec=30)
    if length(ARGS) > 1 
        limit_sec = parse(Int, ARGS[2])
    end
    
    lines = String[]
    open(file) do fr
        append!(lines, readlines(fr))
    end

    sentences = fill("#", length(lines))

    Threads.@threads for i in eachindex(lines)
        line = lines[i]
        startswith(line, '#') && continue
        sentences[i] = get_cg_limited(line, limit)
    end

    for sentence in sentences
        startswith(sentence, '#') && continue
        println(sentence)
    end
end

function get_cg_limited(line, limit)
    if limit < 0
        return get_cell_graph(line)
    else
        tsk = @task get_cell_graph(line)
        schedule(tsk)

        Timer(limit) do timer
            istaskdone(tsk) || Base.throwto(tsk, InterruptException())
        end
        
        try
            return fetch(tsk)
        catch _
            return "[]"
        end
    end
end

process_sentences()

using Pkg
using PackageCompiler


if length(ARGS) != 3
    println(stderr, "Exactly 3 arguments not provided. Using default values for all.")
    fwfomc_dir = pwd()
    out = joinpath(pwd(), "bin")
    precompile_script = joinpath(pwd(), "snippets/precompile_script.jl")
else
    fwfomc_dir, out, precompile_script = ARGS
end


Pkg.activate(fwfomc_dir)
ver = Pkg.project().version

PackageCompiler.create_sysimage(
    ["FastWFOMC"];
    sysimage_path=joinpath(out, "FWFOMC_$ver.so"),
    precompile_execution_file=precompile_script
)

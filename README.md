# Fast WFOMC

Implementation of FastWFOMC algorithm (https://ida.fel.cvut.cz/~kuzelka/pubs/van-bremen_535.pdf) in pure Julia for C2 (FO2 + counting quantifiers).
See also https://jair.org/index.php/jair/article/view/12320/26673.

The implementation does not perform knowledge compilation since [dsharp](https://github.com/QuMuLab/dsharp) is not platform-independent.
Instead, the program uses a (naive) SAT solver to enumerate all models.
However, for larger domains, the SAT solving has never been the bottleneck.

# Running the Program

## Obtaining Julia

First, get **Julia** running! There are several options...

- [download](https://julialang.org/downloads/) and install it on your machine
- run [Docker container](https://hub.docker.com/_/julia)
- ... (use your imagination)

## Obtaining the source code

The package is not registered on **JuliaHub**, so the source codes need to be obtained manually, such as cloning this repository or downloading its contents.

## Instantiating the environments

When using the package for the first time, you need to install all its required dependencies.
Not to worry, Julia will handle it for most part.
Simply ask and you shall receive!

Launch Julia (and activate the Julia environment in the current folder described by `Project.toml`):

```shell
$ julia --project=.
```

Once in Julia REPL, switch into Julia package manager (press `]`).
Note that the closing bracket won't be visible, but the prompt will change.
Afterwards, just type in the instantiation command.

```julia
julia> ]
(FastWFOMC) pkg> instantiate
...
```

## Scripting around

Once you have the package ready to use, you can... use it!

There is a _sandboxing_ environment already prepared in case you want to save yourself some trouble.
It is located in the `scripts` folder.
You just have to instantiate it as well.
For example:

```julia
(FastWFOMC) pkg> activate scripts  # relative path
(scripts) pkg> instantiate
...
(scripts) pkg> <BACKSPACE>
julia> using FastWFOMC
julia> ...
```

Now, you can write whatever Julia program you desire and have it
use the _power_ of **FastWFOMC.jl**.
Just run those programs with the `scripts` environment actived.

There are already some snippets/development leftovers to be found in the `scripts` folder.
Feel free to (re-)use them however you see fit.
A word of warning though... after several hotfixes, API redesigns etc. etc., they might not work as expected.

### Using FastWFOMC from REPL

Run the REPL with the scripting environment active:

```shell
$ julia --project=scripts
```

Type desired commands:

```julia
julia> using FastWFOMC
julia> five_coloured = parse_formula(
    "~E(x, x) & " *
    "(~E(x, y) | E(y, x)) & " *
    "(C1(x) | C2(x) | C3(x) | C4(x) | C5(x)) & " *
    "(~C1(x) | ~C2(x)) & " *
    "(~C2(x) | ~C3(x)) & " *
    "(~C1(x) | ~C3(x)) & " *
    "(~C1(x) | ~C4(x)) & " *
    "(~C2(x) | ~C4(x)) & " *
    "(~C3(x) | ~C4(x)) & " *
    "(~C1(x) | ~C5(x)) & " *
    "(~C2(x) | ~C5(x)) & " *
    "(~C3(x) | ~C5(x)) & " *
    "(~C4(x) | ~C5(x)) & " *
    "(~E(x,y) | (~(C1(x) & C1(y)) & ~(C2(x) & C2(y)) & ~(C3(x) & C3(y)) & ~(C4(x) & C4(y)) & ~(C5(x) & C5(y))))"
);
julia> compute_wfomc(five_coloured, 100)  # compute WFOMC with all weights set to 1
46286...
julia>three_regular = parse_formula(
    "~E(x, x) & " *
    "(~E(x, y) | E(y, x)) & " *
    "(~F(x, y) | E(x, y)) & " *
    "(F(x, y) | ~E(x, y)) & " *
    "(S1(x) | ~F1(x, y)) & " *
    "(S2(x) | ~F2(x, y)) & " *
    "(S3(x) | ~F3(x, y)) & " *
    "(~F(x, y) | F1(x, y) | F2(x, y) | F3(x, y)) & " *
    "(F(x, y) | ~F1(x, y)) & " *
    "(F(x, y) | ~F2(x, y)) & " *
    "(F(x, y) | ~F3(x, y)) & " *
    "(~F1(x, y) | ~F2(x, y)) & " *
    "(~F1(x, y) | ~F3(x, y)) & " *
    "(~F2(x, y) | ~F3(x, y))"
);
julia> n = 6
julia> w = WFOMCWeights{Rational{BigInt}}("S1" => (1, -1), "S2" => (1, -1), "S3" => (1, -1))
julia> cc = CardinalityConstraint("F", 3n)
julia> fill_missing_weights!(w, three_regular)  # sets all missing weights to one (to optional third argument)
julia>
julia> # Compute WFOMC with cardinality constraints
julia> compute_wfomc(three_regular, n, w; ccs=[cc]) // factorial(big(3))^n  # 3265920 / (3!)^6  = 70
julia>
julia>
julia> compute_wfomc_unskolemized("V x ~E(x,x)", 10)
1237940039285380274899124224//1
julia> compute_wfomc_unskolemized("V x E=2 y E(x,y)", 10)
34050628916015625//1
julia> compute_wfomc_unskolemized("V x A(x,x) | ~B(x,x)", 2)
144//1
```

### Executing scripts depending on FastWFOMC

Running things from REPL is nice but not that nice, especially if you are interested in running some experiments over night.
For that occassion, executing an entire script is much better.

That can be done quite easily:

```shell
$ julia --project=scripts scripts/friends_smokers.jl
```

### Working with symbolic weights
Under construction

<!-- If you wish have symbolic weights on the input, the weight construction is a little bit more involved.
**FastWFOMC** uses [Nemo.jl](https://nemocas.github.io/Nemo.jl/dev/) package which offers Julia bindings for MPIR, Flint, Arb and Antic libraries.
The current implementation can only handle weights in polynomial form.

Firstly, we need to construct a polynomial ring:

```julia
julia> using Nemo
julia> R, (x, y) = PolynomialRing(QQ, 2) # create polynomial ring over rational numbers (QQ) with two variables.
```

From now on, all numbers need to be in that ring.
Values (including constants) are not compatible across different rings!

We can adapt the example from above as follows:

```julia
julia> n = 6
julia> # Pass the ring as the first argument, and the function will handle all necessary conversions
julia> w = WFOMCWeights(R, Dict("S1" => (1, -1), "S2" => (1, -1), "S3" => (1, -1), "E" => (x, R(1)), "F" => (y, R(1))))
julia>
julia> cc = CardinalityConstraint("F", 3n)
julia> fill_missing_weights!(w, three_regular, R(1))  # sets all missing weights to one in the ring `R`
julia>
julia> # Compute WFOMC with cardinality constraints
julia> compute_wfomc(three_regular, n, w, [cc]) // factorial(big(3))^n  # 3265920 / (3!)^6  = 70
70*x1^18*x2^18
```

We can, of course, go for larger domains, as well:

```julia
julia> using Nemo, FastWFOMC
julia> three_regular = parse_formula(
           "~E(x, x) & " *
           "(~E(x, y) | E(y, x)) & " *
           "(~F(x, y) | E(x, y)) & " *
           "(F(x, y) | ~E(x, y)) & " *
           "(S1(x) | ~F1(x, y)) & " *
           "(S2(x) | ~F2(x, y)) & " *
           "(S3(x) | ~F3(x, y)) & " *
           "(~F(x, y) | F1(x, y) | F2(x, y) | F3(x, y)) & " *
           "(F(x, y) | ~F1(x, y)) & " *
           "(F(x, y) | ~F2(x, y)) & " *
           "(F(x, y) | ~F3(x, y)) & " *
           "(~F1(x, y) | ~F2(x, y)) & " *
           "(~F1(x, y) | ~F3(x, y)) & " *
           "(~F2(x, y) | ~F3(x, y))"
    );
julia> R, vars = PolynomialRing(QQ, 2)
julia> n = 40
julia> w = WFOMCWeights(R, Dict("S1" => (1, -1), "S2" => (1, -1), "S3" => (1, -1), "E" => (vars[1], 1)))
julia> w["F"] = (vars[2], one(R))
julia> cc = CardinalityConstraint("F", 3n)
julia> fill_missing_weights!(w, three_regular)
julia> @time compute_wfomc(three_regular, n, w, [cc])
    65.410560 seconds (36.61 M allocations: 1.858 GiB, 0.61% gc time, 7.48% compilation time)
89778049701265937722543084795989213798864294652203308686325172979785629648796306050080623820800000*x1^120*x2^120
julia> ans // factorial(big"3")^n
``` 
-->

# # SwarmMakie.jl

module SwarmMakie

using Makie
using Random
import StatsBase:
    mean,
    Histogram,
    fit,
    UnitWeights
import KernelDensity
import StableRNGs

# this is subtyped by e.g. `SimpleBeeswarm` and `VerticallyChallengedBeeswarm`
abstract type BeeswarmAlgorithm end

include("algorithms/simple.jl")
include("algorithms/wilkinson.jl")
include("algorithms/jitter.jl")
include("recipe.jl")

end

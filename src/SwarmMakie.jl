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

abstract type BeeswarmAlgorithm end

include("algorithms/simple.jl")
include("algorithms/wilkinson.jl")
include("algorithms/jitter.jl")
include("recipe.jl")

end

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

include("recipe.jl")
include("algorithms/simple.jl")
## include("algorithms/mkborregaard.jl")
include("algorithms/seaborn.jl")
include("algorithms/wilkinson.jl")
include("algorithms/jitter.jl")
include("algorithms/simple2.jl")

end

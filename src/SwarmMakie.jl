# # SwarmMakie.jl

module SwarmMakie

using Makie
using Random
import StatsBase:
    Histogram,
    fit,
    UnitWeights

include("recipe.jl")
include("algorithms/simple.jl")
# include("algorithms/mkborregaard.jl")
include("algorithms/seaborn.jl")
include("algorithms/wilkinson.jl")

end

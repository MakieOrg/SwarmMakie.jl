# Algorithms

SwarmMakie aims to offer several beeswarm algorithms, which give different results.

Currently, it only offers the [`SimpleBeeswarm`](@ref) algorithm, which is inspired by Matplotlib and Seaborn, and a no-op [`NoBeeswarm`](@ref) struct which simply decomposes back to the original scatter plot.

```@docs; canonical=false
SimpleBeeswarm
NoBeeswarm
```

Code exists for the algorithm suggested by Michael Borregaard in [this StatsPlots.jl PR](https://github.com/JuliaPlots/StatsPlots.jl/pull/61#issuecomment-328853342), but it is currently nonfunctional.  If you'd like to take a crack at getting it working, please do!

We also welcome any new algorithms you may have in mind.  Just open a PR!

## Adding a new algorithm

In order to add a new algorithm, you must simply define a `struct` which subtypes `SwarmMakie.BeeswarmAlgorithm`.

There must also be a corresponding dispatch on `SwarmMakie.calculate!(buffer, alg, positions, markersize)` which loads the new positions calculated in pixel space into `buffer`.




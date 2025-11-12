# Algorithms

SwarmMakie aims to offer several beeswarm algorithms, which give different results.  You can change the algorithm which SwarmMakie uses by passing it as a keyword argument `algorithm`, or mutating `plot.algorithm` after the fact.

Currently, it offers the [`SimpleBeeswarm`](@ref) and [`WilkinsonBeeswarm`](@ref) algorithms, which are inspired by Matplotlib and Leland Wilkinson's original paper respectively, and a no-op [`NoBeeswarm`](@ref) algorithm which simply decomposes back to the original data.

In addition, SwarmMakie offers jittered scatter plots as algorithms to `beeswarm`.  These aren't exactly beeswarm plots since they don't guarantee that all points are non-overlapping, but they can still be useful to show distributions, especially for larger numbers of points where all points cannot fit into a beeswarm.  These algorithms are accessible as [`UniformJitter`](@ref), [`PseudorandomJitter`](@ref), and [`QuasirandomJitter`](@ref), similar to `ggbeeswarm`'s options.

## Overview

Here's an overview of all the available algorithms. Each of the built-in algorithms can be accessed with a `Symbol` as a shorthand.

```@example all_algorithms
using SwarmMakie, CairoMakie

algorithms = [:default, :wilkinson, :uniform, :pseudorandom, :quasirandom, :none]
fig = Figure(; size = (800, 450))
xs = rand(1:3, 400); ys = randn(400)

for (i, algorithm) in enumerate(algorithms)
    beeswarm(
        fig[fldmod1(i, 3)...], xs, ys;
        color = xs, algorithm, markersize = 4,
        axis = (; title = repr(algorithm))
    )
end

fig
```

The jitter algorithms respond to a `width` in data space, similar to how it works for `barplot`.

```@example
using SwarmMakie, CairoMakie

algorithms = [:uniform, :pseudorandom, :quasirandom]
fig = Figure(; size = (800, 450))
xs = rand(1:3, 400); ys = randn(400)

for (j, width) in enumerate([1, 0.5, 0.2])
    for (i, algorithm) in enumerate(algorithms)
        beeswarm(
            fig[i, j], xs, ys;
            color = xs, algorithm, markersize = 4,
            axis = (; title = "$(repr(algorithm)), width = $width"),
            width,
            seed = 123,
        )
    end
end

fig
```

The gap between categories for automatically determined width can be adjusted with the `gap` parameter.

```@example
using SwarmMakie, CairoMakie

fig = Figure()
xs = rand(1:3, 400); ys = randn(400)

for (j, gap) in enumerate([0, 0.3, 0.6])
    beeswarm(
        fig[1, j], xs, ys;
        color = xs, algorithm = :uniform, markersize = 4,
        axis = (; title = "gap = $gap"),
        gap,
        seed = 123,
    )
end

fig
```


## Documentation

```@docs; canonical=false
SimpleBeeswarm
WilkinsonBeeswarm
NoBeeswarm
```

```@docs; canonical=false
UniformJitter
PseudorandomJitter
QuasirandomJitter
```

We also welcome any new algorithms you may have in mind.  Just open a PR!

## Adding a new algorithm

In order to add a new algorithm, you must simply define a `struct` which subtypes `SwarmMakie.BeeswarmAlgorithm`.

There must also be a corresponding dispatch on `SwarmMakie.calculate!(buffer, alg, positions, markersize)` which loads the new positions calculated in pixel space into `buffer`.  Note that `buffer` _must_ be modified here.

See the Wilkinson source page for a deep dive into how to write a beeswarm algorithm!

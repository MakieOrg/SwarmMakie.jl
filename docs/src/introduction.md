```@meta
CurrentModule = SwarmMakie
```

# SwarmMakie

`SwarmMakie` implements beeswarm or swarm plots in Makie.  These are scatter plots which are categorical (or singular) in the x-axis, where the markers are nudged so that each marker is visible and avoids overlap.

The main entry point to the package is the [`beeswarm`](@ref) recipe, which takes the same arguments as Makie's `scatter` plots, and transforms them into a beautiful beeswarm plot!

Being a Makie recipe, you can also use this with AlgebraOfGraphics.

## Quick start

Here's a quick example to get you started:

```@example quickstart
using CairoMakie, SwarmMakie
xs = rand(1:3, 40)
ys = randn(40)
f, a, p = scatter(xs, ys; color = xs)
beeswarm(f[1, 2], xs, ys; color = xs, algorithm = NoBeeswarm())
f
```


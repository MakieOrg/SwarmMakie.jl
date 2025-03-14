[ANN] SwarmMakie.jl: Beeswarm plots for Makie

![](SwarmMakie logo)


`SwarmMakie` implements beeswarm or swarm plots in Makie.  These are scatter plots which are categorical (or singular) in the x-axis, where the markers are nudged so that each marker is visible and avoids overlap.

The main entry point to the package is the [`beeswarm`](@ref) recipe, which takes the same arguments as Makie's `scatter` plots, and transforms them into a beautiful beeswarm plot!

It's a regular Makie recipe, so you can use it with any tool that supports Makie.  SwarmMakie also supports nonlinear scales like log axes.

## Quick start

```julia
using SwarmMakie, CairoMakie
beeswarm(ones(10), rand(10))
```

## Examples

![](multiple_swarm.png) ![](tecosaur_jlbench.png)


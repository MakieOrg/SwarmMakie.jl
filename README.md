# SwarmMakie

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://asinghvi17.github.io/SwarmMakie.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://asinghvi17.github.io/SwarmMakie.jl/dev/)
[![Build Status](https://github.com/asinghvi17/SwarmMakie.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/asinghvi17/SwarmMakie.jl/actions/workflows/CI.yml?query=branch%3Amain)

Beeswarm plots in Makie!

<img src="docs/src/assets/logo.png" width=200/>

## Quick start

The entry point to this package is the `beeswarm` recipe, which accepts input the same way `scatter` does in all respects -- plus a keyword `algorithm`, which specifies the beeswarm algorithm!

```julia
using SwarmMakie, CairoMakie
ys = rand(150)
beeswarm(ones(length(ys)), ys)
```
<img src="https://github.com/asinghvi17/SwarmMakie.jl/assets/32143268/5b422b52-0017-4bd2-8c61-22ad195266b1" width=600/>

```julia
using SwarmMakie, CairoMakie
xs = rand(1:4, 500)
ys = randn(500)
beeswarm(xs, ys; color = xs)
```
<img src="https://github.com/asinghvi17/SwarmMakie.jl/assets/32143268/861f36f9-d431-41a3-8823-6d96edac0017" width=600/>

See the docs for more!

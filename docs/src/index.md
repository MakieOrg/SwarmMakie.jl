````@raw html
---
# https://vitepress.dev/reference/default-theme-home-page
layout: home

hero:
  name: SwarmMakie.jl
  text: 
  tagline: Beeswarm plots for Makie.jl
  image:
    src: /logo.png
    alt: SwarmMakie
  actions:
    - theme: brand
      text: Introduction
      link: /introduction
    - theme: alt
      text: View on Github
      link: https://github.com/MakieOrg/SwarmMakie.jl
    - theme: alt
      text: API Reference
      link: /api
---


<p style="margin-bottom:2cm"></p>

<div class="vp-doc" style="width:80%; margin:auto">
````

# What is SwarmMakie.jl?

SwarmMakie makes beeswarm plots for Makie through the `beeswarm` recipe. These are like categorical scatter plots that distribute points around the category lines so that there's less visual overlap and densities are easier to gauge.


## Quick start

The `beeswarm` recipe accepts similar arguments to `scatter`. 

```@example
using SwarmMakie, CairoMakie

algorithms = [:default, :wilkinson, :none, :uniform, :pseudorandom, :quasirandom]
fig = Figure(; size = (800, 450))
xs = rand(1:3, 400); ys = randn(400)

for (i, algorithm) in enumerate(algorithms)
    beeswarm(
        fig[fldmod1(i, 3)...], xs, ys;
        color = xs, algorithm, markersize = 4,
        axis = (; title = repr(algorithm)),
    )
end

fig
```

````@raw html
</div>
````



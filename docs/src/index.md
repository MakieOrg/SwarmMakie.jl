```@raw html
---
# https://vitepress.dev/reference/default-theme-home-page
layout: home

hero:
  name: "SwarmMakie.jl"
  text: ""
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
      link: https://github.com/asinghvi17/SwarmMakie.jl
    - theme: alt
      text: API Reference
      link: /api

features:
  - icon: <img width="64" height="64" src="https://rawcdn.githack.com/JuliaLang/julia-logo-graphics/f3a09eb033b653970c5b8412e7755e3c7d78db9e/images/juliadots.iconset/icon_512x512.png" alt="Julia code"/>
    title: Pure Julia code
    details: Fast, understandable, extensible functions
    link: /introduction
  - icon: <img width="64" height="64" src="https://fredrikekre.github.io/Literate.jl/v2/assets/logo.png" />
    title: Literate programming
    details: Documented source code with examples!
    link: /source/methods/clipping/cut
  - icon: <img width="64" height="64" src="https://rawcdn.githack.com/JuliaGeo/juliageo.github.io/4788480c2a5f7ae36df67a4b142e3a963024ac91/img/juliageo.svg" />
    title: Full integration with Makie
    details: Use any Makie.jl scatter input!
    link: https://docs.makie.org/stable/
---


<p style="margin-bottom:2cm"></p>

<div class="vp-doc" style="width:80%; margin:auto">

# What is SwarmMakie.jl?

SwarmMakie makes beeswarm plots for Makie through the `beeswarm` recipe.


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


</div>

```


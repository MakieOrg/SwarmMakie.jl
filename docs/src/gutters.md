# Gutters

```@figure gutters; backend=:CairoMakie; type="svg" 
using SwarmMakie, CairoMakie
xs = rand(1:10, 2000)
beeswarm(xs, rand(2000); gutter = 0.3, color = xs)
```

Gutters are a threshold on how far the beeswarm plot can extend from the category point, in data space.

They are off by default, but can be set by passing `gutter::Float64` as a keyword argument or by setting the `gutter` attribute of the plot.  You can turn off guttering by setting `gutter = nothing`, which is the default.

A nice gutter size to avoid overlap in neighboring categories ranges between `0.5` and `0.3` (the latter shown in the example above).

## Examples

```@figure gutters
using SwarmMakie, CairoMakie
f, a, p = beeswarm(
    rand(1:3, 300), randn(300); 
    color = rand(RGBAf, 300), markersize = 20, algorithm = SimpleBeeswarm()
)
p.gutter = 0.5
```
Note the warning messages printed here!  These can be helpful to diagnose when your data is moving too far out of the gutter, but you can turn them off by passing `gutter_threshold = false` or setting the `gutter_threshold` to a higher value (must be an `Int` and >0).
```@figure gutters
f
```

Gutters work with all beeswarm plots.

## Implementation

Gutters are implemented through the `gutterize!` function, and you can overload gutter handling for your own beeswarm type by defining a new dispatch for your algorithm.
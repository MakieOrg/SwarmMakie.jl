# Examples

## Multiple variables with colors

````@example examples
using CairoMakie, SwarmMakie
xs = rand(1:4, 500)
ys = randn(500) .+ xs
fig, ax, plt = beeswarm(xs, ys, color = xs, colormap = :isoluminant_cm_70_c39_n256)
````

Now, we can also pass categorical colormaps:

````@example examples
plt.colormap[] = Makie.Categorical(Makie.wong_colors()[1:4])
````

and the figure is:

````@example examples
fig
````

## Palmer Penguins

````@example examples
using AlgebraOfGraphics, CairoMakie, SwarmMakie

data(AlgebraOfGraphics.penguins()) *
    mapping(:species, :bill_depth_mm, color=:sex) *
    visual(Beeswarm) |> draw
````

## SwarmMakie logo

````@example examples
using CairoMakie, SwarmMakie
using RDatasets, DataFrames
iris = dataset("datasets", "iris")
f, a, p = beeswarm(
    fill(1, length(iris[!, :SepalLength])),
    iris[!, :SepalLength];
    color = iris[!, :Species].refs,
    colormap = Makie.Categorical(RGBAf[RGBAf(0.082f0,0.643f0,0.918f0,1.0f0), RGBAf(0.91f0,0.122f0,0.361f0,1.0f0), RGBAf(0.929f0,0.773f0,0.0f0,1.0f0)]),
    markersize = 20
)
f.scene.backgroundcolor[] = RGBAf(1,1,1,0)
a.scene.backgroundcolor[] = RGBAf(1,1,1,0)
hidedecorations!(a)
hidespines!(a)
f
````

## Wilkinson's dot histogram

````@example examples
using CairoMakie, SwarmMakie
using RDatasets, DataFrames
mtcars = dataset("datasets", "mtcars")

f, a, p = beeswarm(
    ones(length(mtcars[!, :MPG])),
    mtcars[!, :MPG];
    algorithm = SimpleBeeswarm(),
    markersize = 20,
)
p.side = :both
p.direction = :x
f
````

Note that to use `side != :both`, you will have to set the limits of the axis explicitly.

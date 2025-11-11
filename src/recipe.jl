# # Beeswarm recipe

export beeswarm, beeswarm!

export NoBeeswarm

# In this file, we define the `Beeswarm` recipe.

"""
    beeswarm(x, y)
    beeswarm(positions)

`beeswarm` is a `PointBased` recipe like `scatter`, accepting all of `scatter`'s input.  

It displaces points which would otherwise overlap in the x-direction by binning in the y direction. 

## Example

```julia
using Makie, SwarmMakie
beeswarm(ones(100), randn(100); color = rand(RGBf, 100))
```
"""
@recipe Beeswarm begin
    "The algorithm used to lay out the beeswarm markers."
    algorithm = SimpleBeeswarm()
    "The side towards which markers should extend.  Can be `:left`, `:right`, or both."
    side = :both
    "Controls the direction of the beeswarm.  Can be `:y` (vertical) or `:x` (horizontal)."
    direction = :y
    "Creates a gutter of a desired size around each category.  Gutter size is always in data space."
    gutter = nothing
    "Emit a warning of the number of points added to a gutter per category exceeds the threshold."
    gutter_threshold = .5
    Makie.documented_attributes(Scatter)...
end

Makie.conversion_trait(::Type{<: Beeswarm}) = Makie.PointBased()

# This is mostly useful to test the recipe...
"A simple no-op algorithm, which causes the scatter plot to be drawn as if you called `scatter` and not `beeswarm`."
struct NoBeeswarm <: BeeswarmAlgorithm
end

function calculate!(buffer::AbstractVector{<: Point2}, alg::NoBeeswarm, positions::AbstractVector{<: Point2}, markersize, side::Symbol)
    @debug "Calculating..."
    buffer .= positions
    return
end

# Beeswarm plots inherently have an extent that is dependent on the placement
# algorithm and the available space. However, you cannot use the actual placement
# of scatter dots to infer limits, because adjusting the axis given these limits
# invalidates the limits again, and so on, potentially ad infinitum.
#
# Instead, it makes more sense to pick fixed limits given the input data. If
# that doesn't leave enough place for all beeswarms, probably the axis size
# has to be increased, or the marker sized decreased, anyway.
#
# The dimension that's not controlled by the beeswarm placement algorithm we
# can take directly from the input data. For the "categories" or group placement
# values, we simply determine the differences between the unique sorted values and
# increase the width at the sides by half the minimum distance. That means, we create
# equal space for all categories. If the beeswarm doesn't fit that, again, other
# parameters have to be adjusted anway.
function Makie.data_limits(bs::Beeswarm)
    points = bs.converted[][1]
    categories = sort(unique(p[1] for p in points))
    range_1 = if length(categories) == 1
        (only(categories) - 0.5, only(categories) + 0.5)
    else
        mindiff = if isnothing(bs.gutter[])
            minimum(diff(categories))
        else
            bs.gutter[]  
        end
        (first(categories) - mindiff/2, last(categories) + mindiff/2)
    end
    range_2 = extrema(p[2] for p in points)
    bb = if bs.direction[] === :y
        BBox(range_1..., range_2...)
    elseif bs.direction[] === :x
        BBox(range_2..., range_1...)
    else
        error("Invalid direction $(repr(bs.direction[])), expected :x or :y")
    end
    return Rect3f(bb)
end

Makie.boundingbox(s::Beeswarm, space::Symbol = :data) = Makie.apply_transform_and_model(s, Makie.data_limits(s))

function Makie.plot!(plot::Beeswarm)
    Makie.register_projected_positions!(plot, Point2f; input_name = :converted_1, output_name = :projected_points, output_space = :pixel, input_space = :data)

    buffer = Point2f[]

    map!(plot, [:projected_points, :algorithm, :markersize, :side, :direction, :gutter, :gutter_threshold, :converted_1], [:beeswarm, :output_space]) do projected, algorithm, markersize, side, direction, gutter, gutter_threshold, converted_1
        resize!(buffer, length(projected))

        _output_space = output_space(algorithm)

        calculate!(
            buffer,
            algorithm,
            _output_space === :pixel ? projected : converted_1,
            markersize,
            side
        )

        if !isnothing(gutter)
            gutterize!(buffer, algorithm, converted_1, direction, gutter, gutter_threshold)
        end

        return buffer, _output_space
    end

    scatter!(
        plot,
        plot.attributes,
        plot.beeswarm;
        space = plot.output_space,
    )
    return
end

output_space(_) = :pixel

# This function implements "gutters", or regions around each category where points are not allowed to go.
function gutterize!(point_buffer, algorithm::BeeswarmAlgorithm, positions, direction, gutter, gutter_threshold)

    # This gets the x coordinate of all points
    xs = first.(positions)

    # Find all points belonging to all unique categories
    # by finding the unique x values
    idx = 1
    for group in unique(xs)
        
        # Starting index for the group
        group_indices = findall(==(group), xs)

        # Calculate a gutter threshold
        gutter_threshold_count = length(group_indices) * gutter_threshold
        gutter_pts = 0
        for idx in group_indices
            pt = point_buffer[idx]
            x = direction == :y ? pt[1] : pt[2]
            # Check if a point values between a acceptable range
            if x < (group - gutter)
                # Left side of the gutter
                point_buffer[idx] = direction == :y ? Point2f(group - gutter, pt[2]) : Point2f(pt[1], group - gutter)
                gutter_pts += 1
            elseif x > (group + gutter)
                # Right side of the gutter
                point_buffer[idx] = direction == :y ? Point2f(group + gutter, pt[2]) : Point2f(pt[1], group + gutter)
                gutter_pts += 1
            end
            idx += 1
        end

        # Emit warning if too many points fall into the gutter
        if gutter_threshold_count < gutter_pts
            @warn """
            Gutter threshold exceeded for category $(group).  
            $(round(gutter_pts/length(group_indices), digits = 2))% of points were placed in the gutter.
            Consider adjusting the `markersize` for the plot to shrink markers, or the gutter size by `gutter`. 
            """
        end
    end
end

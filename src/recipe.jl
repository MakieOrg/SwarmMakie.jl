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
    algorithm = :default
    "The side towards which markers should extend.  Can be `:left`, `:right`, or both."
    side = :both
    "Controls the direction of the beeswarm.  Can be `:y` (vertical) or `:x` (horizontal)."
    direction = :y
    # TODO: gutter should be reimplemented considering `width` (plus methods to apply to points outside)
    # "Creates a gutter of a desired size around each category.  Gutter size is always in data space."
    # gutter = nothing
    # "Emit a warning of the number of points added to a gutter per category exceeds the threshold."
    # gutter_threshold = .5
    "Width of the jitter columns in data space. By default the smallest difference between categories."
    width = Makie.automatic
    "Gap space reserved from jitter columns as a fraction of width."
    gap = 0.2
    "Random seed for jitter algorithms."
    seed = nothing
    """
    Dodge can be used to separate beeswarms drawn at the same position. For this
    each beeswarm is given an integer value corresponding to its position relative to
    the given positions. E.g. with `positions = [1, 1, 1, 2, 2, 2]` we have
    3 beeswarms at each position which can be separated by `dodge = [1, 2, 3, 1, 2, 3]`.
    """
    dodge = Makie.automatic
    """
    Sets the maximum integer for `dodge`. This sets how many beeswarms can be placed
    at a given position, controlling their width.
    """
    n_dodge = Makie.automatic
    "Sets the gap between dodged beeswarms relative to the size of the dodged beeswarms."
    dodge_gap = 0.03
    Makie.documented_attributes(Scatter)...
end

Makie.conversion_trait(::Type{<: Beeswarm}) = Makie.PointBased()

# This is mostly useful to test the recipe...
"A simple no-op algorithm, which causes the scatter plot to be drawn as if you called `scatter` and not `beeswarm`."
struct NoBeeswarm <: BeeswarmAlgorithm
end

function calculate!(buffer::AbstractVector{<: Point2}, alg::NoBeeswarm, positions::AbstractVector{<: Point2}, markersize, side::Symbol, bin_edges::AbstractVector{<: Tuple{Float64, Float64}})
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
        # mindiff = if isnothing(bs.gutter[])
        #     minimum(diff(categories))
        # else
        #     bs.gutter[]  
        # end
        mindiff = minimum(diff(categories))
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

# Dodge computation functions (adapted from barplot)
scale_width(dodge_gap, n_dodge) = (1 - (n_dodge - 1) * dodge_gap) / n_dodge

function shift_dodge(i, dodge_width, dodge_gap)
    return (dodge_width - 1) / 2 + (i - 1) * (dodge_width + dodge_gap)
end

function compute_x_and_width(x, width, gap, dodge, n_dodge, dodge_gap)
    width === Makie.automatic && (width = 1)
    width *= 1 - gap
    
    if dodge === Makie.automatic
        i_dodge = 1
    elseif eltype(dodge) <: Integer
        i_dodge = dodge
    else
        ArgumentError("The keyword argument `dodge` currently supports only `AbstractVector{<: Integer}`") |> throw
    end
    
    n_dodge === Makie.automatic && (n_dodge = maximum(i_dodge))
    
    dodge_width = scale_width(dodge_gap, n_dodge)
    shifts = shift_dodge.(i_dodge, dodge_width, dodge_gap)
    
    return x .+ width .* shifts, width * dodge_width
end

function Makie.plot!(plot::Beeswarm)
    Makie.register_projected_positions!(plot, Point2f; input_name = :converted_1, output_name = :projected_points, output_space = :pixel, input_space = :data)

    buffer = Point2f[]

    map!(plot, [:projected_points, :algorithm, :markersize, :direction, :converted_1, :width, :gap, :seed, :side, :dodge, :n_dodge, :dodge_gap], [:beeswarm, :output_space]) do projected, algorithm, markersize, direction, converted_1, width, gap, seed, side, dodge, n_dodge, dodge_gap
        resize!(buffer, length(projected))

        # If algorithm is a Symbol, construct the correct struct
        alg_obj::BeeswarmAlgorithm = if algorithm isa Symbol
            if algorithm === :default
                SimpleBeeswarm()
            elseif algorithm === :none
                NoBeeswarm()
            elseif algorithm == :wilkinson
                WilkinsonBeeswarm()
            elseif algorithm == :uniform
                UniformJitter(width=Makie.automatic, gap=gap, seed=seed)
            elseif algorithm == :pseudorandom
                PseudorandomJitter(width=Makie.automatic, gap=gap, seed=seed)
            elseif algorithm == :quasirandom
                QuasirandomJitter(width=Makie.automatic, gap=gap)
            else
                error("Unknown algorithm symbol: $algorithm")
            end
        else
            algorithm
        end

        _output_space = output_space(alg_obj)
        
        # Work in the appropriate space for this algorithm
        positions = _output_space === :pixel ? projected : converted_1
        
        xs = first.(positions)
        ys = last.(positions)
        
        # Calculate base width
        _width::Float64 = if width === Makie.automatic
            uxs = unique(xs)
            diffs = diff(sort(uxs))
            if isempty(diffs)
                # Single x location
                if _output_space === :pixel
                    # use scene width as a heuristic
                    scene = Makie.parent_scene(plot)
                    width = scene.viewport[].widths[1]
                else
                    1.0
                end
            else
                minimum(diffs)
            end
        else
            width
        end
        
        # Apply dodge if needed
        if dodge === Makie.automatic
            xs_final = xs
            final_width = _width * (1 - gap)
        else
            xs_dodged, width_dodged = compute_x_and_width(xs, _width, gap, dodge, n_dodge, dodge_gap)
            xs_final = xs_dodged
            final_width = width_dodged
        end
        
        # Reconstruct positions with final x-coordinates
        positions_final = Point2.(xs_final, ys)
        
        # Compute bin edges for each unique x position
        unique_xs_final = unique(xs_final)
        
        # Create a mapping from x values to bin edges
        x_to_edges = Dict{Float64, Tuple{Float64, Float64}}()
        for x in unique_xs_final
            half_width = final_width / 2
            x_to_edges[Float64(x)] = (Float64(x - half_width), Float64(x + half_width))
        end
        
        # Create bin_edges array matching the order of positions
        bin_edges = [x_to_edges[Float64(x)] for x in xs_final]
        
        calculate!(
            buffer,
            alg_obj,
            positions_final,
            markersize,
            side,
            bin_edges,
        )

        # if !isnothing(gutter)
        #     gutterize!(buffer, alg_obj, converted_1, direction, gutter, gutter_threshold)
        # end

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

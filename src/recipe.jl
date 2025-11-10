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
    algorithm = SimpleBeeswarm2()
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

    map!(plot, [:projected_points, :algorithm, :markersize, :side, :direction, :gutter, :gutter_threshold, :converted_1], :beeswarm) do projected, algorithm, markersize, side, direction, gutter, gutter_threshold, converted_1
        resize!(buffer, length(projected))
        calculate!(buffer, algorithm, projected, markersize, side)

        if !isnothing(gutter)
            gutterize!(buffer, algorithm, converted_1, direction, gutter, gutter_threshold)
        end
        return buffer
    end

    # # this is a bit risky but #YOLO
    # # we extract the plot's parent Scene, from which we can extract
    # # the viewport, i.e., pixelspace!
    # scene = Makie.parent_scene(plot)
    # # Now, we can extract the Scene's limits from the camera's projectionview.
    # # Note that this only works for 2-D Scenes, and gets us the transformed space limits,
    # # so if you're trying to run this in a scene with a `transform_func`, that's something to 
    # # be aware of.
    # final_widths = lift(scene.camera.projectionview) do pv
    #     isnothing(pv) && return Vec2f(0)
    #     xmin, xmax = minmax((((-1, 1) .- pv[1, 4]) ./ pv[1, 1])...)
    #     ymin, ymax = minmax((((-1, 1) .- pv[2, 4]) ./ pv[2, 2])...)
    #     return Makie.Vec2f(xmax - xmin, ymax - ymin)
    # end
    # # and its viewport (in case the scene changes size)
    # pixel_widths = @lift widths($(scene.viewport))
    # old_pixel_widths = Ref(pixel_widths[])
    # old_finalwidths = Ref(final_widths[])

    # should_update_based_on_zoom = Observable{Bool}(true)
    # onany(plot, final_widths, pixel_widths) do fw, pw # if we change more than 5%, recalculate.
    #     if !all(isapprox.(fw, old_finalwidths[]; rtol = 0.1)) || !all(isapprox.(pw, old_pixel_widths[]; rtol = 0.05))
    #         old_pixel_widths[] = pw
    #         old_finalwidths[] = fw
    #         notify(should_update_based_on_zoom)
    #     end
    # end
    # notify(final_widths)

    # # set up buffers
    # point_buffer = Observable{Vector{Point2f}}(zeros(Point2f, length(positions[])))
    # pixelspace_point_buffer = Observable{Vector{Point2f}}(zeros(Point2f, length(positions[])))
    # # when the positions change, we must update the buffer arrays
    # onany(plot, plot.converted[1], plot.algorithm, plot.transformation.transform_func, plot.markersize, plot.side, plot.direction, plot.gutter, plot.gutter_threshold, should_update_based_on_zoom) do positions, algorithm, tfunc, markersize, side, direction, gutter, gutter_threshold, _
    #     @assert side in (:both, :left, :right) "side should be one of :both, :left, or :right, got $(side)"
    #     @assert direction in (:x, :y) "direction should be one of :x or :y, got $(direction)"
    #     if length(positions) != length(point_buffer[])
    #         # recreate the point buffers if lengths have changed
    #         point_buffer.val = copy(positions)
    #         pixelspace_point_buffer.val = zeros(Point2f, length(positions))
    #     end
    #     # Apply nonlinear transform function if any
    #     pixelspace_point_buffer.val .= Makie.apply_transform(tfunc, positions, :data)
    #     # Project input positions from data space to pixel space
    #     pixelspace_point_buffer.val .= Point2f.(Makie.project.((scene.camera,), :data, :pixel, direction == :y ? pixelspace_point_buffer.val : reverse.(pixelspace_point_buffer.val)))
    #     # Calculate the beeswarm in pixel space and store it in `point_buffer.val`
    #     calculate!(point_buffer.val, algorithm, direction == :y ? pixelspace_point_buffer.val : reverse.(pixelspace_point_buffer.val), markersize, side)
    #     # Project the beeswarm back to data space and store it, again, in `point_buffer.val`
    #     point_buffer.val .= Point2f.(Makie.project.((scene.camera,), :pixel, :data, direction == :y ? (point_buffer.val) : reverse.(point_buffer.val)))
    #     # Finally, apply the inverse transform to move back into data space.
    #     # TODO: remove this once we have `space==:transformed` in Makie.
    #     point_buffer.val .= Makie.apply_transform(Makie.inverse_transform(tfunc), point_buffer.val, :data)

    #     # Method to create a gutter when a gutter is defined
    #     # NOTE: Maybe turn this into a helper function?

    #     if !isnothing(gutter)
    #         gutterize!(point_buffer, algorithm, positions, direction, gutter, gutter_threshold)
    #     end


    #     # Finally, update the scatter plot
    #     notify(point_buffer)
    # end
    # # create a set of Attributes that we can pass down
    # attrs = copy(plot.attributes)
    # pop!(attrs, :algorithm)
    # pop!(attrs, :side)
    # pop!(attrs, :direction)
    # pop!(attrs, :gutter)
    # pop!(attrs, :gutter_threshold)
    # # pop!(attrs, :space)
    # attrs[:space] = :data
    # attrs[:markerspace] = :pixel
    # # create the scatter plot
    scatter!(
        plot,
        plot.attributes,
        plot.beeswarm;
        space = :pixel,
    )
    return
end

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

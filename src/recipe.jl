# # Beeswarm recipe

export beeswarm, beeswarm!

export NoBeeswarm

# In this file, we define the `Beeswarm` recipe.

"""
    beeswarm(x, y)
    beeswarm(positions)

`beeswarm` is a `PointBased` recipe like `scatter`, accepting all of `scatter`'s input.  

It displaces points which would otherwise overlap in the x-direction by binning in the y direction. 

Specific attributes to `beeswarm` are:
- `algorithm = SimpleBeeswarm()`: The algorithm used to lay out the beeswarm markers.
- `side = :both`: The side towards which markers should extend.  Can be `:left`, `:right`, or both.  
- `direction = :y`: Controls the direction of the beeswarm.  Can be `:y` (vertical) or `:x` (horizontal).
- `gutter = nothing`: Creates a gutter of a desired size around each category.
- `gutter_threshold = .5`: Emit a warning of the number of points added to a gutter per category exceeds the threshold.

## Arguments
$(Makie.ATTRIBUTES)

## Example

```julia
using Makie, SwarmMakie
beeswarm(ones(100), randn(100); color = rand(RGBf, 100))
```
"""
@recipe(Beeswarm, positions) do scene
    return merge(
        Attributes(
            algorithm = SimpleBeeswarm(),
            side = :both,
            direction = :y,
            gutter = nothing,
            gutter_threshold = .5,
        ),
        default_theme(scene, Scatter),
    )
end

Makie.conversion_trait(::Type{<: Beeswarm}) = Makie.PointBased()

# this is subtyped by e.g. `SimpleBeeswarm` and `VerticallyChallengedBeeswarm`
abstract type BeeswarmAlgorithm end

# This is mostly useful to test the recipe...
"A simple no-op algorithm, which causes the scatter plot to be drawn as if you called `scatter` and not `beeswarm`."
struct NoBeeswarm <: BeeswarmAlgorithm
end

function calculate!(buffer::AbstractVector{<: Point2}, alg::NoBeeswarm, positions::AbstractVector{<: Point2}, markersize, side::Symbol)
    @debug "Calculating..."
    buffer .= positions
    return
end

Makie.data_limits(bs::Beeswarm) = Makie.data_limits(bs.plots[1])

function Makie.plot!(plot::Beeswarm)
    positions = plot.converted[1] # being PointBased, it should always receive a vector of Point2
    @assert positions[] isa AbstractVector{<: Point2} "`positions` should be an `AbstractVector` of `Point2` after conversion, got type $(typeof(positions)).  If you have passed in `x, y, z` input, be aware that `beeswarm` only accepts 2-D input (`x, y`)."

    # this is a bit risky but #YOLO
    # we extract the plot's parent Scene, from which we can extract
    # the viewport, i.e., pixelspace!
    scene = Makie.parent_scene(plot)
    # Now, we can extract the Scene's limits from the camera's projectionview.
    # Note that this only works for 2-D Scenes, and gets us the transformed space limits,
    # so if you're trying to run this in a scene with a `transform_func`, that's something to 
    # be aware of.
    final_widths = lift(scene.camera.projectionview) do pv
        isnothing(pv) && return Vec2f(0)
        xmin, xmax = minmax((((-1, 1) .- pv[1, 4]) ./ pv[1, 1])...)
        ymin, ymax = minmax((((-1, 1) .- pv[2, 4]) ./ pv[2, 2])...)
        return Makie.Vec2f(xmax - xmin, ymax - ymin)
    end
    # and its viewport (in case the scene changes size)
    pixel_widths = @lift widths($(scene.viewport))
    old_pixel_widths = Ref(pixel_widths[])
    old_finalwidths = Ref(final_widths[])

    should_update_based_on_zoom = Observable{Bool}(true)
    onany(plot, final_widths, pixel_widths) do fw, pw # if we change more than 5%, recalculate.
        if !all(isapprox.(fw, old_finalwidths[]; rtol = 0.1)) || !all(isapprox.(pw, old_pixel_widths[]; rtol = 0.05))
            old_pixel_widths[] = pw
            old_finalwidths[] = fw
            notify(should_update_based_on_zoom)
        end
    end
    notify(final_widths)

    #= 
    
    BUG: For some reason, the recipe is not respecting inputs for these new kwargs I defined.
    I am sure I am doing something wrong with the recipe, but as of now, I have made the
    kwarg values constant.

    =#

    gutter = .4 
    gutter_threshold = .55

    # set up buffers
    point_buffer = Observable{Vector{Point2f}}(zeros(Point2f, length(positions[])))
    pixelspace_point_buffer = Observable{Vector{Point2f}}(zeros(Point2f, length(positions[])))
    # when the positions change, we must update the buffer arrays
    onany(plot, plot.converted[1], plot.algorithm, plot.color, plot.markersize, plot.side, plot.direction, should_update_based_on_zoom) do positions, algorithm, colors, markersize, side, direction, _
        @assert side in (:both, :left, :right) "side should be one of :both, :left, or :right, got $(side)"
        @assert direction in (:x, :y) "direction should be one of :x or :y, got $(direction)"
        if length(positions) != length(point_buffer[])
            # recreate the point buffers if lengths have changed
            point_buffer.val = copy(positions)
            pixelspace_point_buffer.val = zeros(Point2f, length(positions))
        end
        # Project input positions from data space to pixel space
        pixelspace_point_buffer.val .= Point2f.(Makie.project.((scene.camera,), :data, :pixel, direction == :y ? positions : reverse.(positions)))
        # Calculate the beeswarm in pixel space and store it in `point_buffer.val`
        calculate!(point_buffer.val, algorithm, direction == :y ? pixelspace_point_buffer.val : reverse.(pixelspace_point_buffer.val), markersize, side)
        # Project the beeswarm back to data space and store it, again, in `point_buffer.val`
        point_buffer.val .= Point2f.(Makie.project.((scene.camera,), :pixel, :data, direction == :y ? (point_buffer.val) : reverse.(point_buffer.val)))

        # Method to create a gutter when a gutter is defined
        # NOTE: Maybe turn this into a helper function?

        if !isnothing(gutter)
            # Get category labels
            groups = [pt[1] for pt in positions] 

            # Sort positions before iterating through values
            sort!([positions], by = x -> x[1])

            # Find all points belonging to all unique categories
            idx = 1
            for group in unique(groups) |> sort
                
                # Starting index for the group
                starting = findfirst(==(group), groups)

                # Last index for the group
                ending = findlast(==(group), groups)

                # Calculate a gutter threshold
                gutter_threshold_count = (ending - starting) * gutter_threshold
                gutter_pts = 0
                for pt in point_buffer.val[starting:ending]
                    # Check if a point values between a acceptable range
                    if pt[1] > (group + gutter) || pt[1] < (group - gutter)
                        if pt[1] < 0
                            # Left side of the gutter
                            point_buffer.val[idx] = Point2f(group - gutter, pt[2])
                        else
                            # Right side of the gutter
                            point_buffer.val[idx] = Point2f(group + gutter, pt[2])
                        end
                        gutter_pts += 1
                    end
                    idx += 1
                end

                # Emit warning if too many points fall into the gutter
                if gutter_threshold_count < gutter_pts
                    @warn "Gutter threshold exceeded for category $group; consider adjusting gutter size"
                end
            end
        end


        # Finally, update the scatter plot
        notify(point_buffer)
    end
    # create a set of Attributes that we can pass down
    attrs = copy(plot.attributes)
    pop!(attrs, :algorithm)
    pop!(attrs, :side)
    pop!(attrs, :direction)
    # pop!(attrs, :space)
    attrs[:space] = :data
    attrs[:markerspace] = :pixel
    # create the scatter plot
    scatter_plot = scatter!(
        plot,
        attrs,
        point_buffer
    )
    notify(should_update_based_on_zoom)
    return
end


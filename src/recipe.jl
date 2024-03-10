# # Beeswarm recipe

export beeswarm, beeswarm!

export NoBeeswarm

# In this file, we define the `Beeswarm` recipe.

@recipe(Beeswarm, positions) do scene
    return merge(
        Attributes(
            algorithm = SimpleBeeswarm(),
        ),
        default_theme(scene, Scatter),
    )
end

Makie.conversion_trait(::Type{<: Beeswarm}) = Makie.PointBased()

# this is subtyped by e.g. `SimpleBeeswarm` and `VerticallyChallengedBeeswarm`
abstract type BeeswarmAlgorithm end

struct NoBeeswarm <: BeeswarmAlgorithm
end

function calculate!(buffer::AbstractVector{<: Point2}, alg::NoBeeswarm, positions::AbstractVector{<: Point2}, markersize)
    @info "Calculating..."
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

    
    # set up buffers
    point_buffer = Observable{Vector{Point2f}}(zeros(Point2f, length(positions[])))
    pixelspace_point_buffer = Observable{Vector{Point2f}}(zeros(Point2f, length(positions[])))
    # when the positions change, we must update the buffer arrays
    onany(plot, plot.converted[1], plot.algorithm, plot.color, plot.markersize, should_update_based_on_zoom) do positions, algorithm, colors, markersize, _
        if length(positions) != length(point_buffer[])
            # recreate the point buffers if lengths have changed
            point_buffer.val = copy(positions)
            pixelspace_point_buffer.val = zeros(Point2f, length(positions))
        end
        # Project input positions from data space to pixel space
        pixelspace_point_buffer.val .= Makie.project.((scene.camera,), :data, :pixel, positions)
        # Calculate the beeswarm in pixel space and store it in `point_buffer.val`
        calculate!(point_buffer.val, algorithm, pixelspace_point_buffer.val, markersize)
        # Project the beeswarm back to data space and store it, again, in `point_buffer.val`
        point_buffer.val .= Makie.project.((scene.camera,), :pixel, :data, point_buffer.val)
        # Finally, update the scatter plot
        notify(point_buffer)
    end
    # create a set of Attributes that we can pass down
    attrs = copy(plot.attributes)
    pop!(attrs, :algorithm)
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


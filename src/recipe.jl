# # Beeswarm recipe

# In this file, we define the `Beeswarm` recipe.

@recipe(Beeswarm, positions) do scene
    return merge(
        Attributes(
            algorithm = NoBeeswarm(),
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
    finalwidths = lift(scene.camera.projection) do pv
        xmin, xmax = minmax((((-1, 1) .- pv[1, 4]) ./ pv[1, 1])...)
        ymin, ymax = minmax((((-1, 1) .- pv[2, 4]) ./ pv[2, 2])...)
        return Makie.Vec2(xmax - xmin, ymax - ymin)
    end
    # and its viewport (in case the scene changes size)
    pixel_widths = @lift widths($(scene.viewport))
    old_pixel_widths = Ref(pixel_widths[])
    old_finalwidths = Ref(finalwidths[])

    should_update_based_on_zoom = Observable(nothing)
    lift(plot, finalwidths, pixel_widths) do fw, pw # if we change more than 5%, recalculate.
        if !all(isapprox.(fw, old_finalwidths[]; rtol = 0.05)) || !all(isapprox.(pw, old_pixel_widths[]; rtol = 0.05))
            old_pixel_widths[] = pw
            old_finalwidths[] = fw
            notify(should_update_based_on_zoom)
        end
    end

    
    # set up buffers
    point_buffer = Observable{Vector{Point2f}}(zeros(Point2f, length(positions[])))
    pixelspace_point_buffer = Observable{Vector{Point2f}}(zeros(Point2f, length(positions[])))
    color_buffer = Observable{Vector{RGBA{Float32}}}()
    # when the positions change, we must update the buffer arrays
    onany(plot, plot.converted[1], plot.algorithm, plot.color, plot.markersize, should_update_based_on_zoom) do positions, algorithm, colors, markersize, _
        if length(positions) != length(point_buffer[])
            # recreate point buffer if lengths have changed
            point_buffer.val = zeros(Point2f, length(positions))
            pixelspace_point_buffer.val = zeros(Point2f, length(positions))
            # color_buffer.val = zeros(RGBA{Float32}, length(positions))
        end
        pixelspace_point_buffer.val .= Makie.project.((scene.camera, ), :data, :pixel, positions)
        calculate!(point_buffer.val, algorithm, pixelspace_point_buffer.val, markersize)
        point_buffer.val .= Makie.project.((scene.camera,), :pixel, :data, pixelspace_point_buffer.val)
        # color_buffer.val .= colors # TODO: figure out some way to make this better.

        # update the scatter plot
        notify(point_buffer)
    end
    # create a set of Attributes that we can pass down
    attrs = copy(plot.attributes)
    pop!(attrs, :algorithm)
    pop!(attrs, :space)
    # attrs[:color] = color_buffer
    attrs[:space] = :data
    attrs[:markerspace] = :pixel
    # create the scatter plot
    scatter_plot = scatter!(
        plot,
        attrs,
        point_buffer
    )
    return
end


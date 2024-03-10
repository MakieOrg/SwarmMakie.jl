# # Wilkinson beeswarm

export WilkinsonBeeswarm

#=
This is a beeswarm implementation as described in Leland Wilkinson's original paper on dot plots
=#

"""
    WilkinsonBeeswarm()

A simple implementation like Matplotlib's algorithm.
"""
struct WilkinsonBeeswarm <: BeeswarmAlgorithm
end

function calculate!(buffer::AbstractVector{<: Point2}, alg::WilkinsonBeeswarm, positions::AbstractVector{<: Point2}, markersize::Real)
    #= 
    
    Initial sketch of code credited to Frederic Freyer and Julius Krumbiegel.
    Reference here: https://github.com/MakieOrg/Makie.jl/issues/1950

    =# 
    @info "Calculating..."
    using Random
    Random.seed!(123)

    f = Figure()
    ax = Axis(f[1, 1])

    xs = 1:15
    binwidth = step(xs)

    ms = lift(ax.scene.px_area, ax.finallimits) do pxa, lims
        widths(pxa)[1] / widths(lims)[1] * binwidth
    end

    dots = lift(ax.scene.px_area, ax.finallimits) do pxa, lims
        counts = rand(1:7, length(xs))
        points = Point2f[]
        for (x, count) in zip(xs, counts)
            for i in 1:count
                push!(
                    points,
                    Point2f(
                        (x - lims.origin[1]) / (lims.widths[1]) * pxa.widths[1],
                        (i - 0.5) * ms[],
                    )
                )
            end
        end
        points
    end

    scatter!(ax, dots, markersize = ms, space = :pixel)
    xlims!(ax, xs.start - 1, xs.stop + 1)
    hideydecorations!(ax)
    # lines(f[1, 2], 1:10) # add other content to figure
    f
end

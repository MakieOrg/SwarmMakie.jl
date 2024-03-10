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

function calculate!(buffer::AbstractVector{<: Point2}, alg::WilkinsonBeeswarm, positions::AbstractVector{<: Point2}, markersize::Real, side::Symbol)
    #= 
    
    Initial sketch of code credited to Frederic Freyer and Julius Krumbiegel.
    Reference here: https://github.com/MakieOrg/Makie.jl/issues/1950

    =# 

    new_positions = Float32[]
    for pos in positions
        push!(new_positions, pos[2]) 
    end
    h = fit(Histogram, new_positions; nbins = markersize)
    xs = 1:length(h.weights)

    dot_per_bin = round.(Int, h.weights ./ markersize)

    points = Point2f[]
    for x in xs
        for dot in 1:dot_per_bin[x]
            point = Point2f(x, dot)
            push!(points, point)
        end
    end
    println(points)

    return points

end

# # Simple beeswarm

export SimpleBeeswarm

"""
    SimpleBeeswarm()

A simple implementation like Matplotlib's algorithm.
"""
struct SimpleBeeswarm <: BeeswarmAlgorithm
end

function calculate!(buffer::AbstractVector{<: Point2}, alg::SimpleBeeswarm, positions::AbstractVector{<: Point2}, markersize)
    ys = last.(positions)
    ymin, ymax = extrema(ys)
    nbins = (ymax - ymin) ÷ markersize
    dy = markersize
    ybins = LinRange(ymin+dy, ymax-dy, nbins-1) # this is a center list of bins
    i = eachindex(ys)
    return
end

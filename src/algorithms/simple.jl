"""
    SimpleBeeswarm()

A simple implementation like Matplotlib's algorithm.
"""
struct SimpleBeeswarm <: BeeswarmAlgorithm
end

function calculate!(buffer::AbstractVector{<: Point2}, alg::SimpleBeeswarm, positions::AbstractVector{<: Point2}, markersize)
    
    buffer .= positions
    return
end

# # Simple beeswarm

export SimpleBeeswarm

"""
    SimpleBeeswarm()

A simple implementation like Matplotlib's algorithm.
"""
struct SimpleBeeswarm <: BeeswarmAlgorithm
end

function calculate!(buffer::AbstractVector{<: Point2}, alg::SimpleBeeswarm, positions::AbstractVector{<: Point2}, markersize)
    @info "Calculating..."
    ys = last.(positions)
    ymin, ymax = extrema(ys)
    nbins = round(Int, (ymax - ymin) ÷ markersize)
    dy = markersize
    ybins = LinRange(ymin+dy, ymax-dy, nbins-1) # this is a center list of bins
    idxs = eachindex(ys)
    bin_idxs = Vector{Vector{Int}}()
    bin_vals = Vector{Vector{eltype(ys)}}()

    for (j, ybin) in enumerate(ybins)
        mask = ys .< ybin
        push!(bin_idxs, idxs[mask])
        push!(bin_vals, ys[mask])
        # Remove the points that are already in the bin
        mask .= (!).(mask)
        idxs = idxs[mask]
        ys = ys[mask]
    end

    # Add the remaning elements to the last bin
    push!(bin_idxs, idxs)
    push!(bin_vals, ys)

    nmax = maximum(length, bin_idxs)

    xs = zeros(eltype(ys), size(positions))
    for (b_idxs, b_vals) in zip(bin_idxs, bin_vals)
        if length(idxs) < 1 # if only 1 element exists, continue
            continue
        else
            j = length(b_idxs) % 2
            resorted_b_idxs = b_idxs[sortperm(b_vals)]
            a = resorted_b_idxs[begin:2:end]
            b = resorted_b_idxs[(begin+1):2:end]
            xs[a] .= ((1:length(a))) .* markersize
            xs[b] .= ((1:length(b))) .* (-markersize)
        end
    end
    buffer .= Point2f.(xs, last.(positions))
end

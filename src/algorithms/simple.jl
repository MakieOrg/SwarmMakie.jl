# # Simple beeswarm

export SimpleBeeswarm

#=
This is a simple beeswarm implementation as used in Matplotlib.
=#

"""
    SimpleBeeswarm()

A simple implementation like Matplotlib's algorithm.  This is the 
default algorithm used in `beeswarm`.
"""
struct SimpleBeeswarm <: BeeswarmAlgorithm
end



function calculate!(buffer::AbstractVector{<: Point2}, alg::SimpleBeeswarm, positions::AbstractVector{<: Point2}, markersize, side::Symbol)
    @info "Calculating..."
    ys = last.(positions)
    xs = first.(positions)

    for x_val in unique(xs)
        group = findall(==(x_val), xs)
        xs[group] .= simple_xs(view(ys, group), markersize, side)
    end
    
    buffer .= Point2f.(xs .+ first.(positions), last.(positions))
end


function simple_xs(ys, markersize, side)
    n_points = length(ys)
    ymin, ymax = extrema(ys)
    nbins = round(Int, (ymax - ymin) ÷ markersize)
    if nbins ≤ 2
        nbins = 3
    end
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

    # nmax = maximum(length, bin_idxs)

    xs = zeros(eltype(ys), n_points)

    for (b_idxs, b_vals) in zip(bin_idxs, bin_vals)
        if length(idxs) < 1 # if only 1 element exists, continue
            continue
        else

            j = length(b_idxs) % 2
            # Resort the indices in the bin by y-value,
            # which allows us to ensure that all markers in the bin
            # are monotonically increasing in the y direction as they 
            # go farther from the center.
            resorted_b_idxs = b_idxs[sortperm(b_vals)]
            if side == :both
                # Split the bin in two parts, evenly split.
                a = resorted_b_idxs[begin:2:end]
                b = resorted_b_idxs[(begin+1):2:end]
                # Populate the x-array.
                xs[a] .= ((1:length(a))) .* markersize .- markersize/2
                xs[b] .= ((1:length(b))) .* (-markersize) .+ markersize/2
            elseif side == :left
                # Populate the x-array.
                xs[resorted_b_idxs] .= ((1:length(resorted_b_idxs))) .* markersize .- markersize/2
            elseif side == :right
                # Populate the x-array.
                xs[resorted_b_idxs] .= ((1:length(resorted_b_idxs))) .* (-markersize) .+ markersize/2
            end
            
        end
    end
    return xs
end
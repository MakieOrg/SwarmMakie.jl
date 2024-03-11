# # Wilkinson beeswarm

export WilkinsonBeeswarm

#=
This is a beeswarm implementation as described in Leland Wilkinson's [original paper on dot plots](https://www.cs.uic.edu/~wilkinson/Publications/dotplots.pdf).

This is probably one of the simplest beeswarm algorithms to implement, so this file is heavily documented
to serve as a reference for other implementations.

## Boilerplate

In order to define a beeswarm algorithm, we need to define a struct that is a subtype of `BeeswarmAlgorithm`.

This may optionally contain fields which control the algorithm, but in this case, we don't need any.
=#

"""
    WilkinsonBeeswarm()

A beeswarm algorithm that implements Leland Wilkinson's original dot-hist algorithm.

This is essentially a histogram with dots, where all dots are binned in the `y` (non-categorical)
direction, and then dodged in the `x` (categorical) direction.  

Original y-coordinates are not preserved, and if you want that try [`SimpleBeeswarm`](@ref) instead.
"""
struct WilkinsonBeeswarm <: BeeswarmAlgorithm
end

#=
## The `calculate!` function

The `calculate!` function is the main function that is called by the `beeswarm!` recipe to calculate the positions of the beeswarm.

It accepts points in pixelspace and marker size through `positions`, 
and sets the elements of `buffer` to the correct positions in pixelspace.

This decreases the amount of memory allocation, as the `buffer` is preallocated.

It is vital that the order of points in `buffer` is the same as in `positions`, since all of the 
other attributes (like color, size, etc.) are indexed by the order of the points in `positions`.

This is why we've essentially reimplemented the histogram here, as opposed to using it from StatsBase.
=#

function calculate!(buffer::AbstractVector{<: Point2}, alg::WilkinsonBeeswarm, positions::AbstractVector{<: Point2}, markersize, side::Symbol)
    @debug "Calculating..."
    # Here, we need to find each unique x-value, which indicates a different group or category.
    xs = first.(positions)
    ## Once we've found this, then we can calculate 
    ## the beeswarm for each group.  
    for x_val in unique(xs)
        group = findall(==(x_val), xs)
        wilkinson_kernel!(view(buffer, group), view(positions, group), markersize, side)
    end
    
end

#=
## The kernel

The `wilkinson_kernel!` function is the main function that calculates the beeswarm for a single group.

It accepts points in pixelspace and marker size through `positions` and `markersize`,
and sets the elements of `buffer` to the correct positions in pixelspace.
=#

function wilkinson_kernel!(buffer, positions, markersize, side::Symbol)
    #= 
    
    Initial sketch of code credited to Frederic Freyer and Julius Krumbiegel.
    Reference here: https://github.com/MakieOrg/Makie.jl/issues/1950

    =# 
    
    ## This code calculates some parameters 
    ## like the minimum and maximum y-values,
    ## and the number of bins.
    ys = last.(positions)
    ymin, ymax = extrema(ys)
    Δy = ymax - ymin
    nbins = round(Int, Δy / markersize)

    ## This will be used for us to push to, and is probably one of
    ## two allocation sources in the code!
    bin_idxs = [Int[] for _ in 1:nbins]

#=
### Binning y-values

We now need to bin the y-values into `nbins` bins.

This is done by looping through each y-value, calculating 
the index of the bin it should be in, and then pushing the index
to the relevant vector in `bin_idxs`.

Since the bins are all uniform, we don't actually need to materialize 
anything!
=#

    for (i, y) in enumerate(ys)
        current_index = round(Int, (y - ymin)/markersize)
        if current_index == 0
            current_index = 1
        elseif current_index > nbins
            current_index = nbins
        end

        push!(bin_idxs[current_index], i)
    end

#=
### Calculating positions

Now that we have the indices of the points in each bin, we can calculate the positions.
We force the points to dodge each other by `markersize`.
=#
    for (i, idxs) in enumerate(bin_idxs)
        isempty(idxs) && continue
        ## This is the center of the bin cell
        current_y = ymin + (i - 1) * markersize + markersize/2
        idxs_by_position = @view idxs[sortperm(last.(@view positions[idxs]))]
        
        if side == :both
            ## Split the bin in two parts, evenly split.
            ## One will go left and one will go right.
            a = idxs_by_position[begin:2:end]
            b = idxs_by_position[(begin+1):2:end]
            ## Update the buffer array.
            buffer[a] .= Point2f.(
                ((1:length(a))) .* markersize .- markersize/2 .+ first.(view(positions, a)),
                current_y
                )
            buffer[b] .= Point2f.(
                ((1:length(b))) .* (-markersize) .+ markersize/2 .+ first.(view(positions, b)),
                current_y
                )
        elseif side == :left
            ## Update the buffer array.
            buffer[idxs_by_position] .= Point2f.(((1:length(idxs_by_position))) .* markersize .- markersize/2 .+ first.(view(positions, idxs_by_position)), current_y)
        elseif side == :right
            ## Update the buffer array.
            buffer[idxs_by_position] .= Point2f.(((1:length(idxs_by_position))) .* (-markersize) .+ markersize/2 .+ first.(view(positions, idxs_by_position)), current_y)
        end
    end
end
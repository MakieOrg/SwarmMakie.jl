# # Seaborn algorithm

export SeabornBeeswarm

#=

This code is adapted from the `seaborn` Python package,
which is licensed under the BSD-3 license below:

```md
Copyright (c) 2012-2023, Michael L. Waskom All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of the project nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```
=#

"""
    SeabornBeeswarm()

A beeswarm algorithm based on the `seaborn` Python package.  

More adaptive to marker size than `SimpleBeeswarm`, 
but takes longer to compute.
"""
struct SeabornBeeswarm <: BeeswarmAlgorithm end

function SwarmMakie.calculate!(buffer::AbstractVector{<: Point2}, alg::SeabornBeeswarm, positions::AbstractVector{<: Point2}, markersize)
    markersizes = if length(markersize) != length(positions)
        fill(markersize, length(positions))
    else
        markersize
    end

    buffer .= _seaborn_beeswarm_xy(positions, markersizes)

end


function _seaborn_beeswarm_xy(positions, markersizes)
    midline = first(positions)[1]

    new_xy = Vector{Point2f}()
    # We have to keep track of the indices, since we can't 
    # re-order the markersize array.
    new_idxs = Vector{Int}()
    for (idx, (position, markersize)) in enumerate(zip(positions, markersizes))

        neighbors = could_overlap(position, markersize, positions, markersizes)

        candidate_positions, candidate_idxs = position_candidates(position, markersize, idx, neighbors, positions, markersizes)

        # Sort candidates by centrality
        offsets = abs.(first.(candidate_positions) .- midline)
        candidate_permutation = sortperm(offsets)
        candidate_positions = candidate_positions[candidate_permutation]
        candidate_idxs = candidate_idxs[candidate_permutation]

        new_position, new_idx = first_non_overlapping_candidate(position, markersize, idx, neighbors, candidate_idxs,candidate_positions, positions, markersizes)
        
        push!(new_xy, new_position)
        push!(new_idxs, new_idx)
    end

    gutterize!(new_xy, markersizes, midline, 7 * maximum(last.(markersizes)))

    return new_xy[new_idxs]

end

"""
    could_overlap(position, markersize, positions, markersizes)

Check if a point given by `position` with markersize `markersize` could overlap with any other point in the swarm.
Returns a vector of integer indices.
"""
function could_overlap(position::Point2, markersize, positions::AbstractVector{<: Point2}, markersizes::AbstractVector)
    potential_neighbors = []
    for (idx, (pos, msize)) in Iterators.reverse(enumerate(zip(positions, markersizes)))
        if abs(position[2] - pos[2]) < (last(msize) + last(markersize)) / 2 # || abs(position[1] - pos[1]) < (first(msize) + first(markersize)) / 2
            push!(potential_neighbors, idx)
        end
    end
    return potential_neighbors
end

"""
Returns `(positions::Vector{Point2f}, idxs::Vector{Int})`.
"""
function position_candidates(position, markersize, idx, neighbors, positions, markersizes)
    candidate_positions = [position]
    candidate_idxs = [idx]
    left_first = true

    for idx in neighbors
        pos = positions[idx]
        ms = markersizes[idx]
        dy = position[2] - pos[2]
        dx = √(max(0, (last(markersize) + last(ms)) ^ 2 - dy ^ 2)) * 1.05
        pl, pr = Point2f(pos[1] - dx, pos[2]), Point2f(pos[1] + dx, pos[2])
        if left_first
            push!(candidate_positions, pl)
            push!(candidate_positions, pr)
            push!(candidate_idxs, idx)
            push!(candidate_idxs, idx)
        else
            push!(candidate_positions, pr)
            push!(candidate_positions, pl)
            push!(candidate_idxs, idx)
            push!(candidate_idxs, idx)
        end
        left_first = !left_first
    end
    return (candidate_positions, candidate_idxs)
end

"""
    Returns `(position::Point2f, idx::Int)`
"""
function first_non_overlapping_candidate(position, markersize, idx, neighbor_idxs, candidate_idxs, candidate_positions, positions, markersizes)
    if length(neighbor_idxs) == 1
        return position, idx
    end

    neighbor_positions = view(positions, neighbor_idxs)
    neighbor_ms = last.(markersizes[neighbor_idxs])

    for (candidate_idx, candidate_position) in zip(candidate_idxs, candidate_positions)
        # We don't need a square root, since we're comparing to another distance measure.
        distances_to_points = sum.(map(x -> x .^ 2, (neighbor_positions .- candidate_position)))

        separation_needed = (neighbor_ms .+ markersizes[candidate_idx]) .^ 2

        if all(distances_to_points .>= separation_needed)
            return positions[candidate_idx], candidate_idx
        end
    end
    error("No non-overlapping candidate found - this should not happen!")
end

function gutterize!(positions, markersizes, center, width = 6 * maximum(last.(markersizes)))
    low_gutter = center - width
    high_gutter = center + width

    off_low = first.(positions) .< low_gutter
    off_high = first.(positions) .> high_gutter

    positions[off_low] .= (low_gutter, last.(positions[off_low]))
    positions[off_high] .= (high_gutter, last.(positions[off_high]))

    gutter_proportion = (sum(off_low) + sum(off_high)) / length(positions)
    if gutter_proportion > 0.05
        @warn """
        SwarmMakie: $(Makie.Format.format("{:.1%}", gutter_proportion)) of the points could not be placed within the width limits.
        You may want to decrease the markersize.
        """
    end
end
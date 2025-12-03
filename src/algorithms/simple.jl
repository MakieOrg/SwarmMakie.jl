# # Simple beeswarm 2 (default)
# This algorithm was contributed by Julius Krumbiegel (@jkrumbiegel) in PR #29.

"""
    SimpleBeeswarm()

A simple beeswarm implementation, that minimizes overlaps. This is the 
default algorithm used in `beeswarm`.

This algorithm dodges in `x` but preserves the exact `y` coordinate of each point.
If you want a more organized appearance and don't need to preserve the exact y coordinates, you can try [`WilkinsonBeeswarm`](@ref).
"""
struct SimpleBeeswarm <: BeeswarmAlgorithm
end

export SimpleBeeswarm

function calculate!(buffer::AbstractVector{<: Point2}, alg::SimpleBeeswarm, positions::AbstractVector{<: Point2}, markersize, side::Symbol, bin_edges::AbstractVector{<: Tuple{Float64, Float64}})
    ys = last.(positions)
    xs = first.(positions)

    for x_val in unique(xs)
        group = findall(==(x_val), xs)
        view_ys = view(ys, group)
        perm = sortperm(view_ys)
        ys_sorted = view_ys[perm]

        ms = if markersize isa Number
            markersize
        else
            if length(unique(markersize[group])) == 1
                markersize[group][1]
            else # this should error
                markersize[group]
            end
        end

        if isempty(ys_sorted)
            continue
        else
            xs[group] .= simple_beeswarm(ys_sorted, ms)[invperm(perm)]
        end
    end
    
    buffer .= Point2f.(xs .+ first.(positions), last.(positions))
end

absmin(a, b) = abs(a) < abs(b) ? a : b

covers_zero(a, b) = a <= 0 && b >= 0

function simple_beeswarm(sorted_ys, markersize)
    @assert issorted(sorted_ys)
    xs = zeros(length(sorted_ys))

    ms_squared = markersize ^ 2

    blocked_x_intervals = Tuple{Float64,Float64}[]

    for i in eachindex(sorted_ys)
        y = sorted_ys[i]

        # store all intervals that the y-adjacent markers are blocking
        empty!(blocked_x_intervals)
        backwards_iter = (i-1):-1:1
        # go backwards through all markers that are overlapping in y
        for j in backwards_iter
            delta_y = y - sorted_ys[j]
            delta_y > markersize && break
            # compute the x distance between two circles that touch, each is markersize
            # in diameter and they are delta_y apart vertically, the current marker would have
            # to be at least that distance away in positive or negative direction
            blocked_delta_x = sqrt(ms_squared - delta_y ^ 2)
            blocked_x = xs[j]
            blocked_x_interval = (blocked_x - blocked_delta_x, blocked_x + blocked_delta_x)
            push!(blocked_x_intervals, blocked_x_interval)
        end

        # we want to go through all blocked intervals from left to right and see
        # if there's a gap between them (a point gap is enough as we've already included
        # the new marker's size in these blocked intervals)
        # the point where we'll place the new marker is either right at the edge of one
        # of these intervals, or it's at zero
        sort!(blocked_x_intervals)

        # this marker can be placed at zero as it doesn't overlap any of the previous ones in y
        isempty(blocked_x_intervals) && continue

        if length(blocked_x_intervals) == 1
            # if there's just one blocked interval, we immediately know what the best value
            # is and the loop below doesn't apply because it starts at 2
            only_interval = blocked_x_intervals[]
            if covers_zero(only_interval...)
                x_closest_to_zero = absmin(blocked_x_intervals[]...)
            else
                x_closest_to_zero = 0.0
            end
        else
            # otherwise our first candidate is the left edge of the first interval
            x_closest_to_zero = first(blocked_x_intervals)[1]
        end

        left_interval = first(blocked_x_intervals)
        for j in 2:length(blocked_x_intervals)
            right_interval = blocked_x_intervals[j]
            
            if right_interval[1] < left_interval[2]
                # if two adjacent intervals overlap, we merge them together for the
                # next loop iteration which we directly go to
                left_interval = (left_interval[1], max(left_interval[2], right_interval[2]))
                # but if we're at the last interval, we will not see another loop iteration, so
                # we have to check the last interval for a candidate directly
                if j == length(blocked_x_intervals) && abs(left_interval[2]) < abs(x_closest_to_zero)
                    x_closest_to_zero = left_interval[2]
                end
                continue
            else
                new_candidate_x = if covers_zero(left_interval[2], right_interval[1])
                    0.0
                elseif abs(left_interval[2]) < abs(right_interval[1])
                    left_interval[2]
                else
                    right_interval[1]
                end
                if abs(new_candidate_x) < abs(x_closest_to_zero)
                    x_closest_to_zero = new_candidate_x
                    left_interval = right_interval
                else
                    # we can't get closer once our candidates start getting worse
                    # than the best one we have so far, which means we're going further
                    # away from zero to the right
                    break
                end
            end
        end
        xs[i] = x_closest_to_zero
    end

    # for better centering, we zero out groups of markers by their mean
    # where each group is separated from its neighbors
    # by a gap of at least one markersize (which means they can't collide when moving horizontally)
    align_group_start = 1
    for i in eachindex(sorted_ys) .+ 1
        if (i - 1) == length(sorted_ys) || sorted_ys[i] - sorted_ys[i-1] >= markersize
            xs[align_group_start:i-1] .-= mean(@view(xs[align_group_start:i-1]))
            align_group_start = i
        end
    end

    return xs
end
using DataFrames
using Random
using RDatasets
using SwarmMakie

iris = dataset("datasets", "iris")

x,y = beeswarm_coords(collect(iris[!, :SepalLength]), :both)

Makie.scatter(x,y, color = iris[!, :Species].refs, markersize = 7, axis = (; aspect = DataAspect()))

using DataFrames, RDatasets, Plots
iris = dataset("datasets", "iris")

x,y = plots_beeswarm_coords(collect(iris[!, :SepalLength]), :both)

scatter(x,y, group = iris[:Species], ms = 7, aspect_ratio = 1, xlim = (-2,2))

SwarmMakie.SimpleBeeswarm()

function beeswarm_coords(olda, side = :both)

       # what should be the new y position of a point given it's x and it's closest point
       getypos(x, ptx, pty, cellsize) = pty + sqrt(cellsize^2-(ptx-x)^2)

       # find the minimum y position for a given point
       function minypos(xind, shift_signs = false)
              neighbors = potential_interactions(xind)
              length(neighbors) == 0 && return NaN
              yvals, xvals = view(ys, neighbors), view(pts, neighbors)
              tmpyvals = shift_signs ? -yvals : yvals
              limit = maximum(tmpyvals .- cellsize)

              ypos = zeros(length(xvals))
              for i in eachindex(xvals)
                     if tmpyvals[i] > limit
                            ypos[i] = getypos(pts[xind], xvals[i], tmpyvals[i], cellsize)
                     end
              end
              ret = maximum(ypos) # Using maxmimum here is not an error - it is the closest point that determines the result
              shift_signs ? -ret : ret
       end

       function update_ypos!(n_ypos, inds, shift_signs = false)
              n_ypos[inds] .= minypos.(inds, shift_signs)
       end

       function potential_interactions(freeind)
              outside_range(x) = abs(pts[freeind]-pts[x])>cellsize
              
              lo = findprev(outside_range, LinearIndices(pts), freeind)
              hi = findnext(outside_range, LinearIndices(pts), freeind)
              if !isnothing(lo) && !isnothing(hi) && (hi -1 >= lo + 1)
                     lo += 1
                     hi -= 1
                     included[freeind] ? (lo:hi)[.!(included[lo:hi])] : (lo:hi)[included[lo:hi]]
              else
                     Int[]
              end
       end

       # estimate a pointsize
       a = sort(shuffle(olda))
       cellsize = (diff([extrema(a)...])/(length(a)^0.6))[1]

       # vectors to hold return values
       included, ys = falses(a), zeros(length(a))

       # fill the first points, that are going to be along the middle line
       ind = start(a)
       nearest_ypos = fill(NaN, length(a))
       while ind != 0
              included[ind] = true
              ind = findfirst(v->v>a[ind] + cellsize, a)
       end

       # now fill the rest in turn
       update_ypos!(nearest_ypos, findall(.!(included)))
       innow = sum(included)

       if side in (:left, :right)
              while innow < length(a)
                     newy, placenext = findmin(nearest_ypos)
                     included[placenext] = true
                     ys[placenext] = newy
                     update_ypos!(nearest_ypos, potential_interactions(placenext))
                     nearest_ypos[placenext] = NaN
                     innow += 1
              end
       elseif side == :both
              nearest_ypos_left = -copy(nearest_ypos)
              nearest_ypos_right = nearest_ypos

              while innow < length(pts)
                     newyleft, placenext_left = findmax(nearest_ypos_left)
                     newyright, placenext_right = findmin(nearest_ypos_right)

                     if -newyleft < newyright
                            placenext = placenext_left
                            included[placenext] = true
                            ys[placenext] = newyleft
                            update_ypos!(nearest_ypos_left, potential_interactions(placenext), true)
                     else
                            placenext = placenext_right
                            included[placenext] = true
                            ys[placenext] = newyright
                            update_ypos!(nearest_ypos_right, potential_interactions(placenext))
                     end

                     nearest_ypos_right[placenext] = NaN
                     nearest_ypos_left[placenext] = NaN
                     innow += 1
              end
       else
              error("side must be :left, :right, or :both")
       end

       rety = zeros(length(pts))
       view(rety, sortperm(pts)) .= nearest_ypos_left

       if side == :left
              rety .*= -1
       end
       rety, olda
end

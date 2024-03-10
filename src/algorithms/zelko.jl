function _potential_interactions(freeind)

end

function _update_ypos!(n_ypos, inds, shift_signs = false)

end

getypos(x, ptx, pty, cellsize) = pty + sqrt(cellsize^2-(ptx-x)^2)

function beeswarm(input_pts)
    pts = sort(input_pts) 

    # Estimating how big to make the cellsizes
    cellsize = (diff([extrema(pts)...])/(length(pts)^0.6))[1]

    # vectors to hold return values
    included = falses(length(pts))
    ys = zeros(length(pts))

    # Calculate the spine of the swarm plot
    ind = 1
    nearest_ypos = fill(NaN, length(pts))
    while !isnothing(ind)
           included[ind] = true
           ind = findfirst(v -> v > pts[ind] + cellsize, pts)
    end

    not_included_inds = findall(.!included)
    update_ypos!(nearest_ypos, findall(.!(included)))

    tind = not_included_inds[1]
    lo = findprev(abs(pts[2] - pts[x]) > cellsize, LinearIndices(pts), 2)

    return pts[included]
end

function zelko_swarm(pts)
    def simple_beeswarm(y, nbins=None):
    """
    Returns x coordinates for the points in ``y``, so that plotting ``x`` and
    ``y`` results in a bee swarm plot.
    """
    y = np.asarray(y)
    if nbins is None:
        nbins = len(y) // 6

    # Get upper bounds of bins
    x = np.zeros(len(y))
    ylo = np.min(y)
    yhi = np.max(y)
    dy = (yhi - ylo) / nbins
    ybins = np.linspace(ylo + dy, yhi - dy, nbins - 1)

    # Divide indices into bins
    i = np.arange(len(y))
    ibs = [0] * nbins
    ybs = [0] * nbins
    nmax = 0
    for j, ybin in enumerate(ybins):
        f = y <= ybin
        ibs[j], ybs[j] = i[f], y[f]
        nmax = max(nmax, len(ibs[j]))
        f = ~f
        i, y = i[f], y[f]
    ibs[-1], ybs[-1] = i, y
    nmax = max(nmax, len(ibs[-1]))

    # Assign x indices
    dx = 1 / (nmax // 2)
    for i, y in zip(ibs, ybs):
        if len(i) > 1:
            j = len(i) % 2
            i = i[np.argsort(y)]
            a = i[j::2]
            b = i[j+1::2]
            x[a] = (0.5 + j / 3 + np.arange(len(b))) * dx
            x[b] = (0.5 + j / 3 + np.arange(len(b))) * -dx

    return x


end

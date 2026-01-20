#####
#
##
#
#####
function directions(ArrayOfDem::AbstractMatrix, edgeList::AbstractVector)

    flow_dir = similar(ArrayOfDem)
    lcp_dir = similar(ArrayOfDem)

    const OFFSETS = CartesianIndex.([
    (-1,  0),  # N
    (-1,  1),  # NE
    ( 0,  1),  # E
    ( 1,  1),  # SE
    ( 1,  0),  # S
    ( 1, -1),  # SW
    ( 0, -1),  # W
    (-1, -1)   # NW
    ])

    dir_dists =  [
        30,                 # N
        hypot(30, 30),      # NE
        30,                 # E
        hypot(30, 30),      # SE
        30,                 # S
        hypot(30, 30),      # SW
        30,                 # W
        hypot(30, 30)       # NW
    ]


    return flow_dir, lcp_dir

end







function flow_direction(dem::Matrix{Float32}, dx::Float64, dy::Float64)

    nrows, ncols = size(dem)
    nan = isnan.(dem)

    flowdir = fill(CartesianIndex(0,0), nrows, ncols)
    dists = neighbor_distances(dx, dy)

    @inbounds for row in 2:nrows-1, col in 2:ncols-1
        nan[row, col] && continue

        z = dem[row, col]
        max_slope = 0.0
        best = CartesianIndex(0,0)

        for k in 1:8
            n = CartesianIndex(row, col) + OFFSETS[k]
            nan[n] && continue

            dz = z - dem[n]
            dz <= 0 && continue

            slope = dz / dists[k]

            if slope > max_slope
                max_slope = slope
                best = OFFSETS[k]
            end
        end

        flowdir[row, col] = best
    end

    return flowdir
end

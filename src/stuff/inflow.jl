#####
#
##
#
#####
function inflow_count(flowdir::Matrix{CartesianIndex})

    nrows, ncols = size(flowdir)
    inflow = zeros(Int, nrows, ncols)

    for row in 1:nrows, col in 1:ncols
        d = flowdir[row, col]
        d == CartesianIndex(0,0) && continue

        r2 = row + d[1]
        c2 = col + d[2]

        inflow[r2, c2] += 1
    end

    return inflow
end

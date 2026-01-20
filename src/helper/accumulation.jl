#####
#
##
#
#####
function flow_accumulation(flowdir::Matrix{CartesianIndex})
    nrows, ncols = size(flowdir)
    acc = ones(Int, nrows, ncols)   # each cell contributes 1
    inflow = inflow_count(flowdir)
    queue = Vector{CartesianIndex}()
    # start with sources (no inflow)
    for row in 1:nrows, col in 1:ncols
        inflow[row, col] == 0 && push!(queue, CartesianIndex(row, col))
    end
    # process upstream → downstream
    while !isempty(queue)
        cell = popfirst!(queue)
        d = flowdir[cell]
        d == CartesianIndex(0,0) && continue
        downstream = cell + d
        acc[downstream] += acc[cell]
        inflow[downstream] -= 1
        inflow[downstream] == 0 && push!(queue, downstream)
    end
    return acc
end


#####
#
##
#
#####

function find_edges(ArrayOfDEM::Matrix{Float32})
    nan_set = Set(findall(isnan.(ArrayOfDEM)))
    not_nan = Set(findall(.!isnan.(ArrayOfDEM)))
    edge_list = Vector{Tuple{CartesianIndex, Float32}}()

    for cell in not_nan
        row, col = tuple(cell)
        if CartesianIndex(row-1, col) in nan_set || # n
            CartesianIndex(row-1, col+1) in nan_set || # ne
            CartesianIndex(row, col+1) in nan_set || # e
            CartesianIndex(row+1, col+1) in nan_set|| # se
            CartesianIndex(row+1, col) in nan_set || # s
            CartesianIndex(row+1, col-1) in nan_set || # sw
            CartesianIndex(row, col-1) in nan_set || # w
            CartesianIndex(row-1, col-1) in nan_set # nw
            push!(edge_list, (cell, ArrayOfDEM[cell]))
        end
    end
    sort!(edge_list, by = x -> x[2]) 
    return edge_list
end
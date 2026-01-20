module HydroTools

export watershedReport

include("./helper/rasterArray.jl")
include("./helper/findEdge.jl")
include("./helper/directions.jl")
include("./helper/excessQ.jl")


function watershedReport(DEMPath::AbstractString)
    demArray = read_raster(DEMPath)

    sorted_list = find_edges(demArray)
    # starting point = sorted_list[1]
    # highest edge = sorted_list[end]
    flow_dir, lcp_dir = directions(demArray, sorted_list)
    
end



end 



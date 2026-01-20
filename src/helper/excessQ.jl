#####
# Clay Karnis
##
# 
#####
function excess_rainoff(CurveNumber::Any, Rainfall::Float32, PrevRainfall::Float32, PrevExcess::Float32)
    
    r = 0.2
    S = (1000/CurveNumber) - 10

    Ia = max(((r*S)-(PrevRainfall + PrevExcess)), 0)

    if rainfall <= Ia
        return 0
    end

    if Rainfall > Ia
        return (Rainfall - Ia)^2 / (Rainfall - Ia + S)
    end
end

excess_rainoff(::Missing, ::Float32, ::Float32, ::Float32) = missing
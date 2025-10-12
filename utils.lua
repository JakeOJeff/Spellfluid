-- Helper Functions
function exp(x) -- Exponential Function
    return math.exp(x)

    --[[
        exp(x)= e^x | e ≈ 2.71828
    ]]
end

floor = math.floor


function clamp(value, lower, upper)
    return math.max(lower, math.min(value, upper))
end
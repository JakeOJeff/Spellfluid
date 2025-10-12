-- Helper Functions
function exp(x) -- Exponential Function
    return math.exp(x)

    --[[
        exp(x)= e^x | e ≈ 2.71828
    ]]
end

function floor(x)
    return math.floor(x)
end

function clamp(value, lower, upper)
    return math.max(lower, math.min(value, upper))
end
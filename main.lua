-- GLOBALS

N = 24 -- resolution
ITER = 8 -- Gauss–Seidel Iteration Method


-- NOTE FROM CREATOR : x and y will be represented as i and j to sync with the formulas


-- Helper Functions
function exp(x) -- Exponential Function
    return math.exp(x)

    --[[
        exp(x)= e^x | e ≈ 2.71828
    ]]
end


-- Global force
function force(Vi, Vj, Fi, Fj, x, y, radius, dt)
    
    --[[
    
        Vi, Vj = Velocity Field Array [ Gridwise ]
        Fi, Fj = External Force Factor Parameter
        x, y = Grid Position ( force center )
        radius = Range of influence
        dt = deltatime 
    
    ]]
    
    for i = (x - radius), (x + radius) do
        for j = (y - radius), (y + radius) do
            if i > 1 and i < N and j > 1 and j < N then
                
                local dx = i - x
                local dy = j - y

                local distanceSq = dx*dx + dy*dy
                if distanceSq < radius * radius then
                    
                end
            end
        end
    end
end
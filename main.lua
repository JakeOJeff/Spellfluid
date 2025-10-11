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
function force(Vx, Vy, Fx, Fy, x, y, radius, dt)
    
    --[[
    
        Vx, Vy = Velocity Field Array [ Gridwise ]
        Fx, Fy = External Force Factor Parameter
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
                local radiusSq = radius * radius
                if distanceSq < radiusSq then
                    local falloff = exp(-distanceSq / radiusSq ) -- 1 - ( distance / radius ) for linear interpolation
                    Vx[i][j] = Vx[i][j] + Fx * falloff * dt
                    Vy[i][j] = Vy[i][j] + Fy * falloff * dt 

                    return Vx, Vy
                end
            end
        end
    end
end


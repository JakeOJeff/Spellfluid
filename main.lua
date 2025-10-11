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

function bound(b, s, n)
    
    for i = 2, (n_- 1) do
        s[i][1] = ( b == 2 ) and -s[i][2] or s[i][2] -- Bottom Bound
        s[i][N] = ( b == 2 ) and -s[i][N-1] or s[i][N-1] -- Top Bound
    end
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


function diffuse(b, s, Bs, diff, dt, iter, N)
    --[[
        Laplacian ( using Laplacian Operator : 2X)
        ∇2X≈Xi−1,j​+Xi+1,j​+Xi,j−1​+Xi,j+1​−4Xi,j​

        b = boundary type ( 
            0 - scalar,
            1 - Vx ( Velocity x-axis )
            2 - Vy ( Velocity y-axis )
        )
        
        s = latest diffused state
        Bs = previous diffused state ( source state )
        iter = number of Gauss-Seidel iterations 
    ]]


    local a = dt * diff * (N - 2)^2

    for k = 1, iter do
        for j = 2, N - 1 do
            for i = 2, N - 1 do
                s[i][j] = (Bs[i][j] + a * ( s[i - 1][j] + s[i + 1][j] + s[i][j - 1] + s[i][j + 1] ) / ( 1 + 4 * a ) )
            end
            -- For Future, create boundary
        end
    end


end

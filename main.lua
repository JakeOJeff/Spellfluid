-- GLOBALS

N = 24 -- resolution
ITER = 8 -- Gauss–Seidel Iteration Method


-- NOTE FROM CREATOR : x and y will be represented as i and j to sync with the formulas


-- Helper Functions
local function exp(x) -- Exponential Function
    return math.exp(x)

    --[[
        exp(x)= e^x | e ≈ 2.71828
    ]]
end

local function floor(x)
    return math.floor(x)
end

local function clamp(value, lower, upper)
    return math.max(lower, math.min(value, upper))
end


local function bound(b, s, N)
    --[[

        Checks if it hits the bounds, if so, invert the velocity

        (1,1)      ...    (N,1)
        .                  .
        .                  .
        (1,N)      ...    (N,N)
    ]]
    for i = 2, (N_- 1) do
        s[i][1] = ( b == 2 ) and -s[i][2] or s[i][2] -- Bottom Bound
        s[i][N] = ( b == 2 ) and -s[i][N-1] or s[i][N-1] -- Top Bound
        s[1][i] = ( b == 1 ) and -s[2][i] or s[2][i] -- Left Bound
        s[N][i] = ( b == 1 ) and -s[N-1][i] or s[N-1][i] -- Right Bound
    end

    -- Corner Cells  = avg of neighbours
    s[1][1] = 0.5 * ( s[2][1] + s[1][2] )
    s[1][N] = 0.5 * ( s[2][N] + s[1][N-1] )
    s[N][1] = 0.5 * ( s[N-1][1] + s[N][2] )
    s[N][N] = 0.5 * ( s[N-1][N] + s[N][N-1])
             
end


-- Global force
function Force(Vx, Vy, Fx, Fy, x, y, radius, dt)
    
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


function Diffuse(b, s, Bs, diff, dt, iter, N)
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
            bound(b, s, N)
        end
    end


end

function Advect(b, a, Ba, Vx, Vy, dt, N)

    Bdt = dt * (N-2)

    for j = 2, N-1 do
        for i = 2, N-1 do
            
            i0 = math.floor()

        end
    end

end
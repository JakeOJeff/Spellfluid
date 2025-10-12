local fluid = {}

-- GLOBALS

N = 24   -- resolution
ITER = 8 -- Gauss–Seidel Iteration Method
DIFF = 0.0001
VISC = 0.001

-- NOTE FROM CREATOR : x and y will be represented as i and j to sync with the formulas

local function bound(b, s, N)
    --[[

        Checks if it hits the bounds, if so, invert the velocity

        (1,1)      ...    (N,1)
        .                  .
        .                  .
        (1,N)      ...    (N,N)
    ]]
    for i = 2, (N - 1) do
        s[i][1] = (b == 2) and -s[i][2] or s[i][2]       -- Bottom Bound
        s[i][N] = (b == 2) and -s[i][N - 1] or s[i][N - 1] -- Top Bound
        s[1][i] = (b == 1) and -s[2][i] or s[2][i]       -- Left Bound
        s[N][i] = (b == 1) and -s[N - 1][i] or s[N - 1][i] -- Right Bound
    end

    -- Corner Cells  = avg of neighbours
    s[1][1] = 0.5 * (s[2][1] + s[1][2])
    s[1][N] = 0.5 * (s[2][N] + s[1][N - 1])
    s[N][1] = 0.5 * (s[N - 1][1] + s[N][2])
    s[N][N] = 0.5 * (s[N - 1][N] + s[N][N - 1])
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

                local distanceSq = dx * dx + dy * dy
                local radiusSq = radius * radius
                if distanceSq < radiusSq then
                    local falloff = exp(-distanceSq / radiusSq)  -- 1 - ( distance / radius ) for linear interpolation
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


    local a = dt * diff * (N - 2) ^ 2

    for k = 1, iter do
        for j = 2, N - 1 do
            for i = 2, N - 1 do
                s[i][j] = (Bs[i][j] + a * (s[i - 1][j] + s[i + 1][j] + s[i][j - 1] + s[i][j + 1]) / (1 + 4 * a))
            end
            bound(b, s, N)
        end
    end
end

function Advect(b, a, Ba, Vx, Vy, dt, N)
    --[[
        / Semi-Lagrangian Advection (Stam’s Method)

        Transporting quantities across velocity field

        Ba = pre advection
        a = post advection

        bilinear interpolation

        note : this is backward tracing instead of forward integration,
        hence, the grid cell content depends on where it came from rather than
        where it might or will go


        ALGORTIHM GENERATED : 

        function advect(b, d, d0, Vx, Vy, dt, N):
            dt0 = dt * (N-2)
            for j = 2 to N-1:
                for i = 2 to N-1:
                    x = i - dt0 * Vx[i,j]
                    y = j - dt0 * Vy[i,j]
                    x = clamp(x, 1.5, N-0.5)
                    y = clamp(y, 1.5, N-0.5)

                    i0 = floor(x)
                    i1 = i0 + 1
                    j0 = floor(y)
                    j1 = j0 + 1

                    s1 = x - i0
                    s0 = 1 - s1
                    t1 = y - j0
                    t0 = 1 - t1

                    d[i,j] = s0*(t0*d0[i0,j0] + t1*d0[i0,j1]) +
                            s1*(t0*d0[i1,j0] + t1*d0[i1,j1])
            set_bnd(b, d, N)
    ]]

    Bdt = dt * (N - 2)

    for j = 2, N - 1 do
        for i = 2, N - 1 do
            x = clamp((i - Bdt * Vx[i][j]), 1.5, N - 0.5)
            y = clamp((j - Bdt * Vy[i][j]), 1.5, N - 0.5)
            i0 = floor(x)
            i1 = i0 + 1
            j0 = floor(y)
            j1 = j0 + 1

            local s1 = x - i0
            local s0 = 1 - s1

            local t1 = y - j0
            local t0 = 1 - t1

            a[i][j] = s0 * ( t0 * Ba[i0][j0] + t1 * Ba[i0][j1] ) +
                      s1 * ( t0 * Ba[i1][j0] + t1 * Ba[i1][j1] )
            
        end
        bound(b, a, N)
    end
end

function Project(Vx, Vy, p, div)

    --[[


        Vx, Vy = Velocity field components
        p = pressure field
        div = divergence map

        Information Stated below are sourced externally [ Algorithms are compiled using Artifical Intelligence ]
    
        Making fluid incompressible

        First for loop ( j x i ) :
            Computes divergence
            Measure how much fluid enters/leaves.
                Enters > Leaves = +ve Divergence
                Leaves > Enters = -ve Divergence

        
        Second for loop :
            Solve for pressure

            Gauss-Seidel relaxtion -> iteratively Poisson Equation
            ∇2p = div
            
            Pressure spreads out evenly - >
                High Pressure areas push back on lower ones

        
        Third for loop :
            Actual projection
            Push the velocity field in the opposite direction of pressure gradient
            balancing out any divergence

            ∇⋅V = 0 [ V is vector, but I am unable to represent that here]

    ]]

    for j = 2, N - 1 do
        for i = 2, N - 1 do
            div[i][j] = -0.5 * (Vx[i + 1][j] - Vx[i - 1][j] + Vy[i][j + 1] - Vy[i][j - 1]) / N
            p[i][j] = 0
        end
    end
    bound(0, div)
    bound(0, p)

    for k = 1, ITER do
        for j = 2, N - 1 do
            for i = 2, N - 1 do
                p[i][j] = (div[i][j] + p[i - 1][j] + p[i + 1][j] + p[i][j - 1] + p[i][j + 1]) / 4

            end     
        end
        bound(0 , p)
    end

    for j = 2, N - 1 do
        for i = 2, N - 1 do
            Vx[i][j] = Vx[i][j] - 0.5 * ( p[i + 1][j] - p[i - 1][j]) * N
            Vy[i][j] = Vy[i][j] - 0.5 * ( p[i][j + 1] - p[i][j - 1]) * N
        end
    end
    bound(1, Vx)
    bound(1, Vy)

end


function fluid:init()

    --[[
    
        fluid = {
        
            density -> Scalar field representing the amount of substance
                       each cell 
            Vx -> horizontal (x-axis) velocity
            Vy -> vertical (y-axis) velocity

        }

    ]]
    self.density = {}
    self.Vx, self.Vy = {}, {}
    self.Vx0, self.Vy0 = {}, {}
    self.s = {}
    self.s0 = {}

    -- 2 dimensional array setup, i for colums and j for rows, using table in table method
    
    --[[
        { 
            { 0, 0, 0}
        }
        {
            { 0, 0, 0}
        }

    ]]
    for i = 1, N do
        self.density[i] = {}
        self.Vx[i], self.Vy[i] = {}, {}
        self.Vx0[i], self.Vy0[i] = {}, {}     
        self.s[i], self.s0 = {}, {}

        for j = 1, N do
            
            self.density[i][j] = 0
            self.Vx[i][j], self.Vy[i][j] = 0, 0
            self.Vx0[i][j], self.Vy0[i][j] = 0, 0
            self.s[i][j], self.s0[i][j] = 0, 0
        end

    end

end

function fluid.simulate(dt)

    --[[
        add viscosity :- 
        spread out velocity vals to neighbouring cells
    ]]
    Diffuse()
    Diffuse()
    Project()

end









return fluid
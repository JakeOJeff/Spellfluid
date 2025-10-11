-- GLOBALS

N = 24 -- resolution
ITER = 8 -- Gauss–Seidel Iteration Method


-- NOTE FROM CREATOR : x and y will be represented as i and j to sync with the formulas

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
            
        end
    end
end
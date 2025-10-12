require "utils"

local fluid = require "fluid"

function love.load()
    size = 8

    fluid:init()

    love.window.setMode(N * size, N * size)
end


function love.update(dt)
    
end

function love.draw()
    --[[

        How this works:
        Assuming there are grids of i x j. We fill each cell of the grid i x j 
        with a rectangle ( cell content ) with a density value of that cell.
        This is done by using a for loop to loop over all the grid cells and their
        corresponding density.
    
    ]]
    for i = 1, N do
        for j = 1, N do
            local d = fluid.density[i][j]
            love.graphics.setColor(1,1,1,d) -- Setting color transparency ~ density
            love.graphics.rectangle("fill", (i-1) * size, (j-1)*size, size, size ) -- Drawing grid elements
        end
    end
end
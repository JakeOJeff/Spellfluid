require "utils"

local fluid = require "fluid"

local mouseDensity = 100

function love.load()
    size = 8

    fluid:init()

    love.window.setMode(N * size, N * size)
end


function love.update(dt)
    fluid:simulate(dt)
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
            local d = math.min(fluid.s[i][j] / 100, 1)
            love.graphics.setColor(d, d, d, 1) -- Setting color transparency ~ density
            love.graphics.rectangle("fill", (i-1) * size, (j-1)*size, size, size ) -- Drawing grid elements
        end
    end
end

function love.mousemoved(x, y, dx, dy)
    if love.mouse.isDown(1) then
        --[[
            Added +1 because Lua Table/Array Index starts at 1
            ( Algorithm used was assumed to be 0 )
        ]]  

        local normX = floor(x / size) + 1
        local normY = floor(y / size) + 1

        normX = clamp(normX, 2, N - 1)
        normY = clamp(normY, 2, N - 1)
        fluid:addDensity(normX, normY, mouseDensity)
        fluid:addVelocity(normX, normY, 20 * dx , 20 * dy)
    end
end



function love.wheelmoved(x, y)
    if y > 0 and mouseDensity < 200 then
        mouseDensity = mouseDensity + 20
    elseif y < 0 then
        mouseDensity = mouseDensity - 20
    end
end
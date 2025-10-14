require "utils"

local fluid = require "fluid"

local mouseDensity = 100

function love.load()
    wW, wH = 720, 720
    pressureMap = false
    size = wW / N
    fluid:init()
    fluid:solidCircle(N / 2, N / 2, 10)
    love.window.setMode(wW, wH)
end

function love.update(dt)
    fluid:simulate(dt)
    if love.keyboard.isDown("d") then
        fluid:create(0, wH / 2, 1, 0, mouseDensity * 2, 20, 0)
    end
    if love.keyboard.isDown("a") then
        fluid:create(wW, wH / 2, -1, 0, mouseDensity * 2, 20, 0)
    end
    if love.keyboard.isDown("s") then
        fluid:create(wW / 2, 0, 0, 1, mouseDensity * 2, 0, 20)
    end
    if love.keyboard.isDown("w") then
        fluid:create(wW / 2, wH, 0, -1, mouseDensity * 2, 0, 20)
    end

    if love.keyboard.isDown("2") then
        fluid:createChannelFlow(true, 10, 15)
    end
end

function love.draw()
    --[[

        How this works:
        Assuming there are grids of i x j. We fill each cell of the grid i x j
        with a rectangle ( cell content ) with a density value of that cell.
        This is done by using a for loop to loop over all the grid cells and their
        corresponding density.

        If object is not solid, draw fluid, else draw the solid object
    ]]

    for i = 1, N do
        for j = 1, N do
            if fluid.boundary[i][j] == 0 then
                local d = math.min(fluid.s[i][j] / 100, 1)
                love.graphics.setColor(1, 1, 1, d)
                if not pressureMap then
                    local r, g, b, d = fluid:getPressureColor(i, j)
                    love.graphics.setColor(r, g, b, d)
                end                                                                             -- Setting color transparency ~ density
                love.graphics.rectangle("fill", (i - 1) * size, (j - 1) * size, size, size)     -- Drawing grid elements
            else
                love.graphics.setColor(0.7, 0.7, 0.7, 1)
                love.graphics.rectangle("fill", (i - 1) * size, (j - 1) * size, size, size)
            end
        end
    end
end

function love.mousemoved(x, y, dx, dy)
    if love.mouse.isDown(1) then
        --[[
            Added +1 because Lua Table/Array Index starts at 1
            ( Algorithm used was assumed to be 0 )
        ]]
        fluid:create(x, y, dx, dy, mouseDensity, 20, 20)
    elseif love.mouse.isDown(2) then
        fluid:create(x, y, dx, dy, -mouseDensity, 20, 20)
    elseif love.mouse.isDown(3) then
        -- fluid:clear(x, y)
        fluid:clearSolids()
        fluid:solidCircle(x / size, y / size, 15)
    end
end

function love.wheelmoved(x, y)
    if y > 0 and mouseDensity < 200 then
        mouseDensity = mouseDensity + 20
    elseif y < 0 and mouseDensity > 20 then
        mouseDensity = mouseDensity - 20
    end
end

function love.keypressed(key)
    if key == "up" and N < 256 then
        N = N * 2
        size = wW / N
        fluid:init()
        fluid:solidCircle(N / 2, N / 2, 10)
    elseif key == "down" and N > 32 then
        N = N / 2
        size = wW / N
        fluid:init()
        fluid:solidCircle(N / 2, N / 2, 10)
    elseif key == "c" then
        fluid:init()
        fluid:solidCircle(N / 2, N / 2, 10)
    elseif key == "p" then
        pressureMap = not pressureMap
        -- Add laminar flow controls
    elseif key == "1" then
        fluid:createLaminarFlow("right", 8, 10, N / 2)
    elseif key == "2" then
        fluid:createChannelFlow(true, 10, 15)
    elseif key == "3" then
        fluid:createShearFlow(8, N / 2)
    elseif key == "4" then
        -- Create multiple parallel flows
        fluid:createLaminarFlow("right", 6, 6, N / 3)
        fluid:createLaminarFlow("right", 6, 6, 2 * N / 3)
    end
end

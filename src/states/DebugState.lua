--[[
    GD50
    Breakout Remake

    -- DebugState Class --

    Represents the screen where we can test various things such as displaying sprites
]]

DebugState = Class{__includes = BaseState}

function DebugState:enter(params)
    -- self.highScores = params.highScores
end

function DebugState:update(dt)
    -- return to the start screen if we press escape
    if love.keyboard.wasPressed('escape') then
        
        gStateMachine:change('start', {
            highScores = self.highScores
        })
    end
end

function DebugState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Debug Screen, do you belong here?', 0, 20, VIRTUAL_WIDTH, 'center')

    local function renderBonus()
        local totalWidth = 16 * 5
        local x = (VIRTUAL_WIDTH / 2) - (totalWidth / 2) - 16
        local y = (VIRTUAL_HEIGHT / 2) - (16 / 2)
        for i = 1, 5 do
            love.graphics.draw(
                gTextures['main'] -- texture
                ,gFrames['bonus'][i] -- quad
                ,x 
                ,y
            )
        end
    end

    renderBonus()
end

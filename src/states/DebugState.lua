--[[
    GD50
    Breakout Remake

    -- DebugState Class --

    Represents the screen where we can test various things such as displaying sprites
]]

DebugState = Class{__includes = BaseState}

function DebugState:enter(params)
    -- self.highScores = params.highScores
    self.items = {}
end

function DebugState:update(dt)
    -- return to the start screen if we press escape
    if love.keyboard.wasPressed('escape') then
        
        gStateMachine:change('start', {
            highScores = self.highScores
        })
    end

    -- spawn a bonus depending on the key pressed
    if love.keyboard.wasPressed('q') then
       table.insert(self.items, Bonus(BONUS_TYPE['paddleShrink']))
       --
    elseif love.keyboard.wasPressed('w') then
       table.insert(self.items, Bonus(BONUS_TYPE['paddleGrow']))
       -- 
    elseif love.keyboard.wasPressed('e') then
       table.insert(self.items, Bonus(BONUS_TYPE['heart']))
       -- 
    elseif love.keyboard.wasPressed('r') then
       table.insert(self.items, Bonus(BONUS_TYPE['moreBalls']))
       -- 
    elseif love.keyboard.wasPressed('t') then
       table.insert(self.items, Bonus(BONUS_TYPE['key']))
       -- 
    end

    -- update active items
    for k, item in pairs(self.items) do
        if item.active then
            item:update(dt)
        end
    end

    -- remove inactive items
    for k, item in pairs(self.items) do
        if not item.active then
            table.remove(self.items, k)
        end
    end
end

function DebugState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Debug Screen, do you belong here?', 0, 20, VIRTUAL_WIDTH, 'center')

    local function testItemSprite()
        local totalWidth = 16 * 5
        local x = (VIRTUAL_WIDTH / 2) - (totalWidth / 2)
        local y = (VIRTUAL_HEIGHT / 2) - (16 / 2)
        for i = 1, 5 do
            love.graphics.draw(
                gTextures['main'] -- texture
                ,gFrames['bonus'][i] -- quad
                ,x
                ,y
            )
            x = x + 16
        end
    end

    local function renderItems()
        for k, item in pairs(self.items) do
            item:render()
        end
    end

    testItemSprite()
    renderItems()
end

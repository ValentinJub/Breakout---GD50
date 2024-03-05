--[[
    This class represents a bonus that the player can otain.

    The bonuses are meant to be spawned from the top of the screen,
    they will slowly fall down the screen and the player needs to touh
    the bonus to get it.

    There are currently 5 bonus items, in order of their index key
        - paddleShrink -> shrinks the paddle for X seconds (not a good bonus!)
        - paddleGrow -> increase the paddle size for X seonds
        - heart -> gives one health point
        - moreBalls -> spawns two additional balls
        - key -> allows breaking the locked brick(s)
]]

Bonus = Class{}

-- As defined in constantes.lua
-- BonusType = {
--     ['paddleShrink'] = 1,
--     ['paddleGrow'] = 2,
--     ['heart'] = 3,
--     ['moreBalls'] = 4,
--     ['key'] = 5
-- }

function Bonus:init(type)
    --[[ 
        we don't want to spawn bonus items randomly,
        we want to have a control over which item is spawned
    ]]

    self.type = type
    -- random x coordinate
    self.x = math.random(16, VIRTUAL_WIDTH - 16)
    -- define y to spawn the bonus over the screen
    self.y = -16
    self.dy = 5

    -- when self.active is false the bonus should be removed
    self.active = true

end

function Bonus:update(dt)

    -- every frame increase y position until it exits the screen
    if self.y < VIRTUAL_HEIGHT then
        self.y = self.y + self.dy * dt
    else 
        self.active = false
    end

end

function Bonus:render()

    -- render our bonus on the screen
    love.graphics.draw(
        gTextures['main'],
        gFrames['bonus'][self.type],
        self.x,
        self.y
    )
end
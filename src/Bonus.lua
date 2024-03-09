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
    self.y = math.random(-48,-16)
    self.dy = 15

    -- when self.active is false the bonus should be removed
    self.active = true

    self.width = 16
    self.height = 16

end

-- getter function
function Bonus:getType() return self.type end

function Bonus:update(dt)

    -- every frame increase y position until it exits the screen
    if self.y < VIRTUAL_HEIGHT then
        self.y = self.y + (self.dy * GAME_SPEED) * dt
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

-- return true when the bonus collides with target
-- target is expected to be the paddle
function Bonus:collides(target)

    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end
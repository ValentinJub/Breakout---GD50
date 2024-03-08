--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.level = params.level

    -- array that can contain more than one ball
    self.balls = {params.ball}

    -- keep track of elapsed tiime
    self.timer = 0

    -- counts consecutive brick hits
    self.combo = 0

    -- add bonus array
    self.items = {}

    -- add item spawn trackers
    self.heartSpawned = false
    self.shrinkSpawned = false
    self.growSpawned = false
    self.moreBallsItemSpawned = false
    self.keySpawned = false

    -- give ball random starting velocity
    self.balls[1].dx = math.random(-200, 200)
    self.balls[1].dy = math.random(-50, -60)
end

function PlayState:update(dt)

    -- update our timer to keep track of elapsed time
    self.timer = self.timer + dt

    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return

    -- for testing items
    elseif love.keyboard.wasPressed('e') then
        table.insert(self.items, Bonus(BONUS_TYPE['paddleGrow']))
    elseif love.keyboard.wasPressed('r') then
        table.insert(self.items, Bonus(BONUS_TYPE['paddleShrink']))
    elseif love.keyboard.wasPressed('t') then
        table.insert(self.items, Bonus(BONUS_TYPE['moreBalls']))
    elseif love.keyboard.wasPressed('y') then
        table.insert(self.items, Bonus(BONUS_TYPE['key']))
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
            -- remove paddle flags
            if item:getType() == 1 then
                self.shrinkSpawned = false
            elseif item:getType() == 2 then
                self.growSpawned = false
            end
            table.remove(self.items, k)
        end
    end

    -- spawn health items if life is lower than 3 and combo is multiple of 10
    if self.health < 3 then
        if self.combo > 0 and self.combo % 10 == 0 then
            if not self.heartSpawned then
                table.insert(self.items, Bonus(BONUS_TYPE['heart']))
                self.heartSpawned = true
            end
        else
            self.heartSpawned = false
        end
    end

    -- spawn grow paddle item when HP = 1 & paddle size is <= medium
    if self.health < 2 and self.paddle.size < 3 and not self.growSpawned then
        table.insert(self.items, Bonus(BONUS_TYPE['paddleGrow']))
        self.growSpawned = true
    end

    -- spawn paddle shrink item when the life is 3 & the paddle size is larger than medium
    if self.health == 3 and self.paddle.size > 2 and not self.shrinkSpawned then
        table.insert(self.items, Bonus(BONUS_TYPE['paddleShrink']))
        self.shrinkSpawned = true
    end

    -- spawn more balls ITEM when the combo is ....
    if self.combo % 5 == 0 and tablelength(self.balls) < 2 then
        if not self.moreBallsItemSpawned then
            table.insert(self.items, Bonus(BONUS_TYPE['moreBalls']))
            self.moreBallsItemSpawned = true
        end 
    else 
        self.moreBallsItemSpawned = false
    end

    -- update positions based on velocity
    self.paddle:update(dt)

    -- udpate balls positions
    for k, ball in pairs(self.balls) do
        ball:update(dt)
    end

    -- keep track of the current skin & size should we change paddle size
    local skin = self.paddle.skin
    local size = self.paddle.size
    local paddleX = self.paddle.x

    -- check for item collision with the paddle
    for i, item in pairs(self.items) do
       --[[
        No need to check if the item is active as 
        the inactive ones got removed in the loop above
       ]]
       if item:collides(self.paddle) then
        -- retrieve the bonus type and act accordingly
        local type = item:getType()
        -- simple test case
        if type == BONUS_TYPE['heart'] then
            self.health = math.min(3, self.health + 1)
            gSounds['powerup']:play()
        elseif type == BONUS_TYPE['paddleShrink'] then
            self.paddle = Paddle({
                size = math.max(size - 1, 1),
                skin = skin,
                x = paddleX
            })
        elseif type == BONUS_TYPE['paddleGrow'] then 
            self.paddle = Paddle({
                size = math.min(size + 1, 4),
                skin = skin,
                x = paddleX
            })
        elseif type == BONUS_TYPE['moreBalls'] then
            local balls_in_play = tablelength(self.balls)
            -- make sure we only have one ball in the balls array
            if balls_in_play < 3 then
            -- spawn two balls above the paddle and activate them
                for k = balls_in_play + 1, 3 do
                    local newskin = math.random(7)
                    table.insert(self.balls, Ball(newskin))

                    -- position the ball on the paddle
                    self.balls[k].x = self.paddle.x + (self.paddle.width / 2) - 4
                    self.balls[k].y = self.paddle.y - 8

                    -- give ball random starting velocity
                    self.balls[k].dx = math.random(-200, 200)
                    self.balls[k].dy = math.random(-50, -60)
                end
            end
        elseif type == BONUS_TYPE['key'] then 
            -- do something
        end
        -- set the item to inactive to remove it at the next frame
        item.active = false
       end
    end

    for p, ball in pairs(self.balls) do
        if ball:collides(self.paddle, "paddle") then
            -- raise ball above paddle in case it goes below it, then reverse dy
            ball.y = self.paddle.y - 8
            ball.dy = -ball.dy

            --
            -- tweak angle of bounce based on where it hits the paddle
            --

            -- if we hit the paddle on its left side while moving left...
            if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
            
            -- else if we hit the paddle on its right side while moving right...
            elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
            end
            gSounds['paddle-hit']:play()
        end

        -- detect collision across all bricks with the ball
        for k, brick in pairs(self.bricks) do

            -- only check collision if we're in play
            if brick.inPlay and ball:collides(brick, "brick") then

                -- add to combo
                self.combo = self.combo + 1

                -- add to score
                self.score = self.score + (brick.tier * 200 + brick.color * 25)

                -- trigger the brick's hit function, which removes it from play
                brick:hit()

                -- go to our victory screen if there are no more bricks left
                if self:checkVictory() then
                    gSounds['victory']:play()
                    
                    gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        ball = self.balls[1], -- only return one ball
                    })
                end

                --
                -- collision code for bricks
                --
                -- we check to see if the opposite side of our velocity is outside of the brick;
                -- if it is, we trigger a collision on that side. else we're within the X + width of
                -- the brick and should check to see if the top or bottom edge is outside of the brick,
                -- colliding on the top or bottom accordingly 
                --

                -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                if ball.x + 2 < brick.x and ball.dx > 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x - 8
                
                -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x + 32
                
                -- top edge if no X collisions, always check
                elseif ball.y < brick.y then
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y - 8
                
                -- bottom edge if no X collisions or top collision, last possibility
                else
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y + 16
                end

                -- slightly scale the y velocity to speed up the game, capping at +- 150
                if math.abs(ball.dy) < 150 then
                    ball.dy = ball.dy * 1.02
                end

                -- only allow colliding with one brick, for corners
                break
            end
        end

        -- if ball goes below bounds, revert to serve state and decrease health
        if ball.y >= VIRTUAL_HEIGHT then
            ball.active = false
        end
    end

    -- remove balls that fell out of bounds
    for k, ball in pairs(self.balls) do
        if not ball.active then
            table.remove(self.balls, k)
        end
    end

    -- return to save state if we lost all the balls
    if tablelength(self.balls) == 0 then
        self.health = self.health - 1
            gSounds['hurt']:play()
            self.combo = 0

            if self.health == 0 then
                gStateMachine:change('game-over', {
                    score = self.score,
                    highScores = self.highScores
                })
            else
                gStateMachine:change('serve', {
                    paddle = self.paddle,
                    bricks = self.bricks,
                    health = self.health,
                    score = self.score,
                    highScores = self.highScores,
                    level = self.level,
                })
            end
    end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    -- to quit the game
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    -- render all items (if any) on screen
    for k, item in pairs(self.items) do
        item:render()
    end

    -- render combo
    if self.combo > 0 then
        love.graphics.setFont(gFonts['small'])
        love.graphics.printf("Combo x" .. self.combo
            ,0
            ,VIRTUAL_HEIGHT - 12
            ,VIRTUAL_WIDTH - 5
            ,'right')
    end

    self.paddle:render()

    -- render each ball
    for k, ball in pairs(self.balls) do
        ball:render()
    end

    renderScore(self.score)
    renderHealth(self.health)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end
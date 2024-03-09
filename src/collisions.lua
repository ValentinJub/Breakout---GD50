--[[
    GD50
    Breakout Remake

    -- StartState Class --

    Author: Valentin Wissler
    valentinwissler42@outlook.com

    Ball collision function
]]

--[[ 
    Handles up to three balls colliding with each other, there seem
    to be a better way to code this maybe, to allow less code.

]]


function handleBallCollisions(balls)

    local maxBalls = tablelength(balls)

    if maxBalls == 1 then return
    elseif maxBalls == 2 then
        local ball1, ball2 = balls[1], balls[2]
        if ball1:collides(ball2) then
            gSounds['ballmeetball']:play()
            -- ball1 hit ball2 from the left and is going right
            if ball1.x < ball2.x and ball1.dx > 0 then
                -- they have the same dy, only invert their dx
                if (ball1.dy < 0 and ball2.dy < 0) or (ball1.dy > 0 and ball2.dy > 0) then
                    ball1.dx = -ball1.dx
                    ball2.dx = -ball2.dx
                else
                    ball1.dy = -ball1.dy
                    ball2.dy = -ball2.dy
                    ball1.dx = -ball1.dx
                    ball2.dx = -ball2.dx
                end            
                -- reset position outside of ball2
                ball1.x = ball2.x - 8

            -- ball1 hit ball2 from the right and is going left
            elseif ball1.x + 8 > ball2.x + ball2.width and ball1.dx < 0 then
                -- they have the same dy, only invert their dx
                if (ball1.dy < 0 and ball2.dy < 0) or (ball1.dy > 0 and ball2.dy > 0) then
                    ball1.dx = -ball1.dx
                    ball2.dx = -ball2.dx
                else
                    ball1.dy = -ball1.dy
                    ball2.dy = -ball2.dy
                    ball1.dx = -ball1.dx
                    ball2.dx = -ball2.dx
                end
                -- reset position outside of ball2
                ball1.x = ball2.x + ball2.width + 1

            -- top edge if no X collisions, always check
            elseif ball1.y < ball2.y then
                ball1.dy = -ball1.dy
                ball2.dy = -ball2.dy
                ball1.y = ball2.y - ball1.height - 1

            -- bottom edge if no X collisions or top collision, last possibility
            else
                ball1.dy = -ball1.dy
                ball2.dy = -ball2.dy
                ball1.y = ball2.y + ball2.height + 1
            end
        end
    elseif maxBalls == 3 then
        local ball1, ball2, ball3 = balls[1], balls[2], balls[3]
        if ball1:collides(ball2) then
            gSounds['ballmeetball']:play()
            -- ball1 hit ball2 from the left and is going right
            if ball1.x < ball2.x and ball1.dx > 0 then
                -- they have the same dy, only invert their dx
                if (ball1.dy < 0 and ball2.dy < 0) or (ball1.dy > 0 and ball2.dy > 0) then
                    ball1.dx = -ball1.dx
                    ball2.dx = -ball2.dx
                else
                    ball1.dy = -ball1.dy
                    ball2.dy = -ball2.dy
                    ball1.dx = -ball1.dx
                    ball2.dx = -ball2.dx
                end            
                -- reset position outside of ball2
                ball1.x = ball2.x - 8
            
            -- ball1 hit ball2 from the right and is going left
            elseif ball1.x + 8 > ball2.x + ball2.width and ball1.dx < 0 then
                -- they have the same dy, only invert their dx
                if (ball1.dy < 0 and ball2.dy < 0) or (ball1.dy > 0 and ball2.dy > 0) then
                    ball1.dx = -ball1.dx
                    ball2.dx = -ball2.dx
                else
                    ball1.dy = -ball1.dy
                    ball2.dy = -ball2.dy
                    ball1.dx = -ball1.dx
                    ball2.dx = -ball2.dx
                end
                -- reset position outside of ball2
                ball1.x = ball2.x + ball2.width + 1
            
            -- top edge if no X collisions, always check
            elseif ball1.y < ball2.y then
                ball1.dy = -ball1.dy
                ball2.dy = -ball2.dy
                ball1.y = ball2.y - ball1.height - 1
            
            -- bottom edge if no X collisions or top collision, last possibility
            else
                ball1.dy = -ball1.dy
                ball2.dy = -ball2.dy
                ball1.y = ball2.y + ball2.height + 1
            end
        end
        if ball1:collides(ball3) then
            gSounds['ballmeetball']:play()
            -- ball1 hit ball3 from the left and is going right
            if ball1.x < ball3.x and ball1.dx > 0 then
                -- they have the same dy, only invert their dx
                if (ball1.dy < 0 and ball3.dy < 0) or (ball1.dy > 0 and ball3.dy > 0) then
                    ball1.dx = -ball1.dx
                    ball3.dx = -ball3.dx
                else
                    ball1.dy = -ball1.dy
                    ball3.dy = -ball3.dy
                    ball1.dx = -ball1.dx
                    ball3.dx = -ball3.dx
                end            
                -- reset position outside of ball3
                ball1.x = ball3.x - 8
            
            -- ball1 hit ball3 from the right and is going left
            elseif ball1.x + 8 > ball3.x + ball3.width and ball1.dx < 0 then
                -- they have the same dy, only invert their dx
                if (ball1.dy < 0 and ball3.dy < 0) or (ball1.dy > 0 and ball3.dy > 0) then
                    ball1.dx = -ball1.dx
                    ball3.dx = -ball3.dx
                else
                    ball1.dy = -ball1.dy
                    ball3.dy = -ball3.dy
                    ball1.dx = -ball1.dx
                    ball3.dx = -ball3.dx
                end
                -- reset position outside of ball3
                ball1.x = ball3.x + ball3.width + 1
            
            -- top edge if no X collisions, always check
            elseif ball1.y < ball3.y then
                ball1.dy = -ball1.dy
                ball3.dy = -ball3.dy
                ball1.y = ball3.y - ball1.height - 1
            
            -- bottom edge if no X collisions or top collision, last possibility
            else
                ball1.dy = -ball1.dy
                ball3.dy = -ball3.dy
                ball1.y = ball3.y + ball3.height + 1
            end
        end
        if ball2:collides(ball3) then
            gSounds['ballmeetball']:play()
            -- ball2 hit ball3 from the left and is going right
            if ball2.x < ball3.x and ball2.dx > 0 then
                -- they have the same dy, only invert their dx
                if (ball2.dy < 0 and ball3.dy < 0) or (ball2.dy > 0 and ball3.dy > 0) then
                    ball2.dx = -ball2.dx
                    ball3.dx = -ball3.dx
                else
                    ball2.dy = -ball2.dy
                    ball3.dy = -ball3.dy
                    ball2.dx = -ball2.dx
                    ball3.dx = -ball3.dx
                end            
                -- reset position outside of ball3
                ball2.x = ball3.x - 8
            
            -- ball2 hit ball3 from the right and is going left
            elseif ball2.x + 8 > ball3.x + ball3.width and ball2.dx < 0 then
                -- they have the same dy, only invert their dx
                if (ball2.dy < 0 and ball3.dy < 0) or (ball2.dy > 0 and ball3.dy > 0) then
                    ball2.dx = -ball2.dx
                    ball3.dx = -ball3.dx
                else
                    ball2.dy = -ball2.dy
                    ball3.dy = -ball3.dy
                    ball2.dx = -ball2.dx
                    ball3.dx = -ball3.dx
                end
                -- reset position outside of ball3
                ball2.x = ball3.x + ball3.width + 1
            
            -- top edge if no X collisions, always check
            elseif ball2.y < ball3.y then
                ball2.dy = -ball2.dy
                ball3.dy = -ball3.dy
                ball2.y = ball3.y - ball2.height - 1
            
            -- bottom edge if no X collisions or top collision, last possibility
            else
                ball2.dy = -ball2.dy
                ball3.dy = -ball3.dy
                ball2.y = ball3.y + ball3.height + 1
            end
        end
    end
end
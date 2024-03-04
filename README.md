# Breakout

Project #3 from: https://cs50.harvard.edu/games/2018/projects/2/breakout/

# Objectives

- Add a powerup to the game that spawns two extra Balls.
- Grow and shrink the Paddle when the player gains enough points or loses a life.
- Add a locked Brick that will only open when the player collects a second new powerup, a key, which should only spawn when such a Brick exists and randomly as per the Ball powerup.

# My additions

- Added a Combo counter

![alt text](image.png)

- Modified the ball collision:
    - The ball now doesn't bounce off the paddle if the center of the ball is below the center of the paddle.   
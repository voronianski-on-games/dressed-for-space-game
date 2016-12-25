debug = true

local player = require('./src/player')
local bullets = require('./src/bullets')

local bgImage = nil

function love.load ()
  bgImage = love.graphics.newImage('assets/bg1.png')
  player.loadAssets()
  bullets.loadAssets()
end

function love.update (dt)
  player.updateShooter(dt)

  if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
    player.rotateRight(dt)
  end

  if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
    player.rotateLeft(dt)
  end

  if love.keyboard.isDown('s') or love.keyboard.isDown('down') then
    player.accelerateBackwards(dt)
  end

  if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
    player.accelerateForward(dt)
  end

  if (love.keyboard.isDown('x') or love.keyboard.isDown('space')) and player.canShoot then
    bullets.create(player, dt)
    player.shoot()
  end

  bullets.update(dt)
  player.update(dt)
end

function love.keypressed (key)
  if key == 'lcmd' and key == 'q' then
    love.event.push('quit')
  end
end

function love.draw ()
  love.graphics.draw(bgImage, 0, 0)
  bullets.draw()
  player.draw()

  if debug then
    local fps = tostring(love.timer.getFPS())
    love.graphics.print('Current FPS: ' .. fps, 10, 10)
  end
end

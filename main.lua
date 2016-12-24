local player = require('./src/player')
local bullets = require('./src/bullets')

function love.load ()
  player.loadAssets()
  bullets.loadAssets()
end

function love.update (dt)
  if love.keyboard.isDown('lcmd') and love.keyboard.isDown('q') then
    love.event.push('quit')
  end

  player.updateShooter(dt)

  if love.keyboard.isDown('right') then
    player.rotateRight(dt)
  end

  if love.keyboard.isDown('left') then
    player.rotateLeft(dt)
  end

  if love.keyboard.isDown('down') then
    player.accelerateBackwards(dt)
  end

  if love.keyboard.isDown('up') then
    player.accelerateForward(dt)
  end

  if (love.keyboard.isDown('x') or love.keyboard.isDown('space')) and player.canShoot then
    bullets.create(player)
    player.shoot()
  end

  player.update(dt)
  bullets.update(dt)
end

function love.draw ()
  bullets.draw()
  player.draw()
end

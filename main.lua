local Camera = require('vendor/gamera')
local _ = require('src/common')
local player = require('src/player')
local bullets = require('src/bullets')

local bgQuad, bgImage, camera

function love.load ()
  camera = Camera.new(_.WORLD_ORIGIN_X, _.WORLD_ORIGIN_Y, _.WORLD_WIDTH, _.WORLD_HEIGHT)

  bgImage = love.graphics.newImage('assets/stars-bg.png')
  bgImage:setWrap('repeat', 'repeat')
  bgQuad = love.graphics.newQuad(_.WORLD_ORIGIN_X, _.WORLD_ORIGIN_Y, _.WORLD_WIDTH, _.WORLD_HEIGHT, bgImage:getWidth(), bgImage:getHeight())

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

  bullets.move(dt)
  player.move(dt)
  camera:setPosition(player.x, player.y)
end

function love.keypressed (key)
  if key == 'lcmd' and key == 'q' then
    love.event.push('quit')
  end
end

function love.draw ()
  camera:draw(function ()
    love.graphics.draw(bgImage, bgQuad, 0, 0)
    bullets.draw()
    player.draw()
  end)

  if _.debug then
    local fps = tostring(love.timer.getFPS())
    love.graphics.print('Current FPS: ' .. fps, 10, 10)
    love.graphics.print('Bulllets count: ' .. bullets.count(), 10, 25)
  end
end

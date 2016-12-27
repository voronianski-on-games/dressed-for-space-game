local _ = require('src/common')

local INITIAL_X = _.WORLD_WIDTH / 2
local INITIAL_Y = _.WORLD_HEIGHT / 2
local CAN_SHOOT_TIMER_MAX = 0.5
local ANGLE_ACCELERATION = 5
local ACCELERATION = 150

local canShootTimer = CAN_SHOOT_TIMER_MAX
local shootSound
local player = {
  x = INITIAL_X,
  y = INITIAL_Y,
  xvel = 0,
  yvel = 0,
  img = nil,
  speed = 300,
  rotation = 0,
  canShoot = true
};

function player.loadAssets ()
  player.img = love.graphics.newImage('assets/player.png')
  shootSound = love.audio.newSource('assets/2.wav', 'static')
end

function player.rotateLeft (dt)
  player.rotation = player.rotation - ANGLE_ACCELERATION * dt
end

function player.rotateRight (dt)
  player.rotation = player.rotation + ANGLE_ACCELERATION * dt
end

function player.accelerateBackwards (dt)
  player.xvel = player.xvel - ACCELERATION * dt * math.cos(player.rotation)
  player.yvel = player.yvel - ACCELERATION * dt * math.sin(player.rotation)
end

function player.accelerateForward (dt)
  player.xvel = player.xvel + ACCELERATION * dt * math.cos(player.rotation)
  player.yvel = player.yvel + ACCELERATION * dt * math.sin(player.rotation)
end

function player.move (dt)
  -- infinite world bounds for player
  _.checkWorldBounds(player, player.img:getWidth(), player.img:getHeight())

  player.x = player.x + player.xvel * dt
  player.y = player.y + player.yvel * dt
  player.xvel = player.xvel * 0.99
  player.yvel = player.yvel * 0.99
end

function player.updateShooter (dt)
  canShootTimer = canShootTimer - dt

  if canShootTimer < 0 then
    player.canShoot = true
  end
end

function player.shoot ()
  shootSound:play()
  player.canShoot = false
  canShootTimer = CAN_SHOOT_TIMER_MAX
end

function player.draw ()
  love.graphics.draw(player.img, player.x, player.y, player.rotation, 1, 1, player.img:getWidth() / 2, player.img:getHeight() / 2)
end

function player.data ()
  return player
end

return player

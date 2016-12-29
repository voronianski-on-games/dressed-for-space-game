local _ = require('src/common')

local initialX = _.WORLD_WIDTH / 2
local initialY = _.WORLD_HEIGHT / 2
local canShootTimerMax = 0.5
local angleAcceleration = 5
local acceleration = 200
local canShootTimer = canShootTimerMax
local playerScale = 1
local playerImage
local shootSound

local player = {
  x = initialX,
  y = initialY,
  xvel = 0,
  yvel = 0,
  rotation = 0,
  canShoot = true,
  lives = 3,
  isAlive = true
};


function player.loadAssets ()
  shootSound = love.audio.newSource('assets/player_shoot.wav', 'static')

  playerImage = love.graphics.newImage('assets/player.png')
  player.width = playerImage:getWidth()
  player.height = playerImage:getHeight()
end

function player.rotateLeft (dt)
  player.rotation = player.rotation - angleAcceleration * dt
end

function player.rotateRight (dt)
  player.rotation = player.rotation + angleAcceleration * dt
end

function player.accelerateBackwards (dt)
  player.xvel = player.xvel - acceleration * dt * math.cos(player.rotation)
  player.yvel = player.yvel - acceleration * dt * math.sin(player.rotation)
end

function player.accelerateForward (dt)
  player.xvel = player.xvel + acceleration * dt * math.cos(player.rotation)
  player.yvel = player.yvel + acceleration * dt * math.sin(player.rotation)
end

function player.move (dt)
  -- infinite world bounds for player
  _.checkWorldBounds(player)

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
  canShootTimer = canShootTimerMax
end

function player.draw ()
  love.graphics.draw(playerImage, player.x, player.y, player.rotation, playerScale, playerScale, player.width / 2, player.height / 2)
end

function player.data ()
  return player
end

return player

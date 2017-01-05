local lume = require('vendor/lume')
local _ = require('src/common')
local Entity = require('src/entity')
local Bullet = require('src/bullet')

local canShootTimerMax = 0.5
local angleAcceleration = 5
local acceleration = 200
local playerScale = 1
local playerImage = nil
local shootSound = nil

local Player = Entity:extend()

Player.drawOrder = 2
Player.updateOrder = 1

function Player.loadAssets ()
  shootSound = love.audio.newSource('assets/player_shoot.wav', 'static')
  playerImage = love.graphics.newImage('assets/player.png')
end

function Player:new (data)
  Player.super.new(self, lume.extend(data, {
    kind = 'player',
    image = playerImage
  }))

  self.canShootTimer = canShootTimerMax
  self.canShoot = true
  self.lives = 3
  self.isAlive = true
end

function Player:update (dt)
  if not self.isAlive then return end

  self:updateShooter(dt)

  if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
    self:rotateRight(dt)
  end

  if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
    self:rotateLeft(dt)
  end

  if love.keyboard.isDown('s') or love.keyboard.isDown('down') then
    self:accelerateBackwards(dt)
  end

  if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
    self:accelerateForward(dt)
  end

  if (love.keyboard.isDown('x') or love.keyboard.isDown('space')) and self.canShoot then
    local center = self:getCenter()

    Bullet({
      x = center.x,
      y = center.y,
      rotation = self.rotation,
      world = self.world,
      camera = self.camera
    })

    -- self.camera:shake(2)
    self:shoot()
  end

  self:move(dt)
end

function Player:rotateLeft (dt)
  self.rotation = self.rotation - angleAcceleration * dt
end

function Player:rotateRight (dt)
  self.rotation = self.rotation + angleAcceleration * dt
end

function Player:accelerateBackwards (dt)
  self.xvel = self.xvel - acceleration * dt * math.cos(self.rotation)
  self.yvel = self.yvel - acceleration * dt * math.sin(self.rotation)
end

function Player:accelerateForward (dt)
  self.xvel = self.xvel + acceleration * dt * math.cos(self.rotation)
  self.yvel = self.yvel + acceleration * dt * math.sin(self.rotation)
end

function Player:collisionFilter (item, other)
  -- if other:is(Bullet) then
  return false
end

function Player:move (dt)
  -- infinite world bounds for player
  _.checkWorldBounds(self)

  local futureX = self.x + self.xvel * dt
  local futureY = self.y + self.yvel * dt
  local nextX, nextY, collisions, len = self.world:move(self, futureX, futureY, self.collisionFilter)

  self.x = nextX
  self.y = nextY
  self.xvel = self.xvel * 0.99
  self.yvel = self.yvel * 0.99
end

function Player:updateShooter (dt)
  self.canShootTimer = self.canShootTimer - dt

  if self.canShootTimer < 0 then
    self.canShoot = true
  end
end

function Player:shoot ()
  shootSound:play()
  self.canShoot = false
  self.canShootTimer = canShootTimerMax
end

return Player

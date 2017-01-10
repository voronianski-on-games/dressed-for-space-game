local lume = require('vendor/lume')
local _ = require('src/common')
local Entity = require('src/entity')
local Bullet = require('src/bullet')
local Explosion = require('src/explosion')

local playerImage = nil
local shootSound = nil
local deathSound = nil

local Player = Entity:extend()

Player.drawOrder = 2
Player.updateOrder = 1

function Player.loadAssets ()
  playerImage = love.graphics.newImage('assets/player.png')
  shootSound = love.audio.newSource('assets/player_shoot.wav', 'static')
  deathSound = love.audio.newSource('assets/death.wav', 'static')
end

function Player:new (data)
  Player.super.new(self, lume.extend(data, {
    kind = 'player',
    image = playerImage
  }))

  self.lives = 3
  self.points = 0
  self.isAlive = true
  self.acceleration = 200
  self.angleAcceleration = 5
  self.canShoot = true
  self.canShootTimerMax = 0.5
  self.canShootTimer = self.canShootTimerMax
  self.approachRadius = 200
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
    self:shoot()
  end

  self:move(dt)
end

function Player:rotateLeft (dt)
  self.rotation = self.rotation - self.angleAcceleration * dt
end

function Player:rotateRight (dt)
  self.rotation = self.rotation + self.angleAcceleration * dt
end

function Player:accelerateBackwards (dt)
  self.xvel = self.xvel - self.acceleration * dt * math.cos(self.rotation)
  self.yvel = self.yvel - self.acceleration * dt * math.sin(self.rotation)
end

function Player:accelerateForward (dt)
  self.xvel = self.xvel + self.acceleration * dt * math.cos(self.rotation)
  self.yvel = self.yvel + self.acceleration * dt * math.sin(self.rotation)
end

function Player:collisionFilter (item, other)
  return false
end

function Player:move (dt)
  self:checkWorldBounds()

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
  local center = self:getCenter()

  Bullet({
    x = center.x,
    y = center.y,
    rotation = self.rotation,
    world = self.world,
    camera = self.camera
  })

  shootSound:play()

  self.canShoot = false
  self.canShootTimer = self.canShootTimerMax
end

function Player:die ()
  self.isAlive = false
  self:destroy()
  self.camera:shake(8)
  deathSound:play()

  Explosion({
    x = self.x,
    y = self.y,
    world = self.world,
    camera = self.camera,
    effectName = 'fx1'
  })
end

return Player

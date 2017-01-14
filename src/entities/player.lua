local lume = require('vendor/lume')
local Timer = require('vendor/timer')
local _ = require('src/common')
local Entity = require('src/entities/entity')
local Bullet = require('src/entities/bullet')
local Explosion = require('src/entities/explosion')

local playerImage = nil
local shootSound = nil
local deathSound = nil

local Player = Entity:extend()

Player.drawOrder = 2
Player.updateOrder = 1

function Player.loadAssets ()
  playerImage = love.graphics.newImage('assets/images/player.png')
  shootSound = love.audio.newSource('assets/sounds/player_shoot.wav', 'static')
  deathSound = love.audio.newSource('assets/sounds/death.wav', 'static')
end

function Player:new (data)
  Player.super.new(self, lume.extend(data, {
    kind = 'player',
    image = playerImage
  }))

  self.lives = 3
  self.points = 0
  self.isAlive = true
  self.isVisible = true
  self.isInvincible = false
  self.acceleration = 200
  self.angleAcceleration = 5
  self.canShoot = true
  self.canShootTimerMax = 0.5
  self.canShootTimer = self.canShootTimerMax
  self.approachRadius = 200
  self.timer = Timer.new()

  self:makeInvincible(3)
end

function Player:update (dt)
  if not self.isAlive then return end

  self.timer:update(dt)
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

function Player:draw ()
  if self.isVisible then
    Player.super.draw(self)
  end
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

function Player:collisionFilter (other)
  if other.kind == 'gem' then
    return 'cross'
  end
end

function Player:move (dt)
  self:checkWorldBounds()

  local futureX = self.x + self.xvel * dt
  local futureY = self.y + self.yvel * dt
  local nextX, nextY, collisions, len = self.world:move(self, futureX, futureY, self.collisionFilter)

  for i = 1, len do
    local other = collisions[i].other

    if other.kind == 'gem' then
      self:collectPoints(other.points)
      other:pick()
    end
  end

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
    camera = self.camera,
    player = self
  })

  shootSound:play()

  self.canShoot = false
  self.canShootTimer = self.canShootTimerMax
end

function Player:die ()
  if self.isInvincible then
    return
  end

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

function Player:makeInvincible (seconds)
  local timePassed = 0
  local function onUpdate (dt)
    timePassed = timePassed + dt
    self.isVisible = (timePassed % 0.2) < 0.1
  end
  local function after ()
    self.isVisible = true
    self.isInvincible = false
  end

  self.isInvincible = true
  self.timer:during(seconds, onUpdate, after)
end

function Player:collectPoints (points)
  self.points = self.points + points
end

return Player

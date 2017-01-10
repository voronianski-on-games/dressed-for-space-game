local lume = require('vendor/lume')
local _ = require('src/common')
local Entity = require('src/entity')
local Explosion = require('src/explosion')

local enemyImage = nil
local damageSound = nil
local deathSound = nil

local Enemy = Entity:extend()

Enemy.drawOrder = 2
Enemy.updateOrder = 1

function Enemy.loadAssets ()
  enemyImage = love.graphics.newImage('assets/enemy.png')
  damageSound = love.audio.newSource('assets/shoot_destroy.wav')
  deathSound = love.audio.newSource('assets/explosion_02.wav')
end

function Enemy:new (data)
  Enemy.super.new(self, lume.extend(data, {
    kind = 'enemy',
    image = enemyImage,
    width = 36,
    height = 36
  }))

  self.player = data.player
  self.healthPoints = 5
  self.seekForce = 5
  self.maxSpeed = 250
end

function Enemy:collisionFilter (other)
end

function Enemy:seek ()
  local dx = self.player.x - self.x
  local dy = self.player.y - self.y
  local desired = _.normalizeVector(dx, dy)

  desired.x = desired.x * self.maxSpeed
  desired.y = desired.y * self.maxSpeed

  self:rotateToPlayer(desired.x, desired.y)

  return self:calculateSteer(desired.x, desired.y)
end

function Enemy:seekWithApproach ()
  local dx = self.player.x - self.x
  local dy = self.player.y - self.y
  local distance = _.getVectorLength(dx, dy)
  local desired = _.normalizeVector(dx, dy)

  -- slowdown when come closer to player
  if distance < self.player.approachRadius then
    desired.x = desired.x * distance / self.player.approachRadius * self.maxSpeed
    desired.y = desired.y * distance / self.player.approachRadius * self.maxSpeed
  else
    desired.x = desired.x * self.maxSpeed
    desired.y = desired.y * self.maxSpeed
  end

  self:rotateToPlayer(desired.x, desired.y)

  return self:calculateSteer(desired.x, desired.y)
end

function Enemy:calculateSteer (dx, dy)
  local steer = {
    x = dx - self.xvel,
    y = dy - self.yvel
  }

  if _.getVectorLength(steer.x, steer.y) > self.seekForce then
    steer.x = steer.x * self.seekForce
    steer.y = steer.y * self.seekForce
  end

  return steer
end

function Enemy:rotateToPlayer (dx, dy)
  self.rotation = math.atan2(dy, dx)
end

function Enemy:accelerate (dt)
  -- steering behavior - seek player
  local acceleration = self:seekWithApproach()

  self.xvel = self.xvel + acceleration.x * dt
  self.yvel = self.yvel + acceleration.y * dt
end

function Enemy:move (dt)
  self:checkWorldBounds()

  local futureX = self.x + self.xvel * dt
  local futureY = self.y + self.yvel * dt
  local nextX, nextY, collisions, len = self.world:move(self, futureX, futureY, self.collisionFilter)

  self.x = nextX
  self.y = nextY
  self.xvel = self.xvel * 0.99
  self.yvel = self.yvel * 0.99
end

function Enemy:update (dt)
  self:accelerate(dt)
  self:move(dt)
end

function Enemy:draw (lx, ly)
  local center = self:getCenter()

  love.graphics.draw(
    self.image,
    center.x, center.y,
    self.rotation,
    self.xscale, self.yscale,
    center.ox + 6, center.oy + 14
  )
end

function Enemy:damage ()
  damageSound:play()

  self.camera:shake(2)
  self.healthPoints = self.healthPoints - 1

  if self.healthPoints <= 0 then
    self:die()
  end
end

function Enemy:die ()
  self:destroy()
  self.camera:shake(5)
  deathSound:play()

  Explosion({
    x = self.x - 20,
    y = self.y - 20,
    world = self.world,
    camera = self.camera
  })
end

return Enemy

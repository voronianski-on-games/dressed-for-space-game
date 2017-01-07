local lume = require('vendor/lume')
local _ = require('src/common')
local Entity = require('src/entity')
local Explosion = require('src/explosion')

local acceleration = 50
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
end

function Enemy:collisionFilter (other)
  -- if other.kind == 'bullet' then
  --   return 'touch'
  -- end
  -- return other.kind == 'bullet'
end

function Enemy:seek ()
  local dx = self.player.x - self.x - self.xvel
  local dy = self.player.y - self.y - self.yvel

  -- normalize
  local len = math.sqrt(dx*dx + dy*dy)
  dx,dy = dx / len, dy / len

  return dx, dy
end

function Enemy:update (dt)
  local dx, dy = self:seek()

  -- self.rotation = math.atan2(dx, dy) + 5 * dt
  self.xvel = self.xvel + dx * 100 * dt -- * math.cos(self.rotation)
  self.yvel = self.yvel + dy * 100 * dt -- * math.sin(self.rotation)

  _.checkWorldBounds(self)

  local futureX = self.x + self.xvel * dt
  local futureY = self.y + self.yvel * dt
  local nextX, nextY, collisions, len = self.world:move(self, futureX, futureY, self.collisionFilter)

  self.x = nextX
  self.y = nextY
  self.xvel = self.xvel * 0.99
  self.yvel = self.yvel * 0.99
end

function Enemy:draw ()
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

local lume = require('vendor/lume')
local _ = require('src/common')
local Entity = require('src/entity')
local Explosion = require('src/explosion')

local acceleration = 100
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

  self.healthPoints = 5
end

function Enemy:collisionFilter (other)
  -- if other.kind == 'bullet' then
  --   return 'touch'
  -- end
  -- return other.kind == 'bullet'
end

function Enemy:update (dt)
  self.xvel = self.xvel + acceleration * dt * math.cos(self.rotation)
  self.yvel = self.yvel + acceleration * dt * math.sin(self.rotation)

  local futureX = self.x + self.xvel * dt
  local futureY = self.y + self.yvel * dt
  local nextX, nextY, collisions, len = self.world:move(self, futureX, futureY, self.collisionFilter)

  -- print('enemy update', len)

  -- for i = 1, len do
    -- local other = collisions[i].other

    -- print('collide', other.kind)
    -- if self.healthPoints <= 0 then
      -- self:die()
    -- else
      -- self:damage()
    -- end
  -- end

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

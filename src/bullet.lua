local lume = require('vendor/lume')
local _ = require('src/common')
local Entity = require('src/entity')

local bulletSpeed = 500
local bulletImage = nil

local Bullet = Entity:extend()

Bullet.drawOrder = 1
Bullet.updateOrder = 2

function Bullet.loadAssets ()
  bulletImage = love.graphics.newImage('assets/bullet.png')
end

function Bullet:new (data)
  Bullet.super.new(self, lume.extend(data, {
    kind = 'bullet',
    -- scale = 0.6,
    image = bulletImage
  }))
end

function Bullet:collisionFilter (other)
  if other.kind == 'enemy' then
    return 'touch'
  end

  return false
end

function Bullet:update (dt)
  local futureX = self.x + math.cos(self.rotation) * bulletSpeed * dt
  local futureY = self.y + math.sin(self.rotation) * bulletSpeed * dt
  local nextX, nextY, collisions, len = self.world:move(self, futureX, futureY, self.collisionFilter)

  for i = 1, len do
    -- print(collisions[i])
    local other = collisions[i].other

    if other.kind == 'enemy' then
      -- self:destroy()
    end
  end

  self.x = nextX
  self.y = nextY

  -- clean bullets when they are out of visible world bounds
  local x, y, width, height = self.camera:getVisible()

  if self.x > x + width or self.x < x or self.y > y + height or self.y < y then
    self:destroy()
  end
end

return Bullet

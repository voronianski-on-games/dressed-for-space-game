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
    image = bulletImage
  }))

  self.maxSpeed = 500
end

function Bullet:collisionFilter (other)
  if other.kind == 'enemy' then
    return 'touch'
  end
end

function Bullet:update (dt)
  self:move(dt)
  self:cleanIfUnused()
end

function Bullet:move (dt)
  local futureX = self.x + math.cos(self.rotation) * self.maxSpeed * dt
  local futureY = self.y + math.sin(self.rotation) * self.maxSpeed * dt
  local nextX, nextY, collisions, len = self.world:move(self, futureX, futureY, self.collisionFilter)

  for i = 1, len do
    local other = collisions[i].other

    if other.kind == 'enemy' then
      self:destroy()
      other:damage()
    end
  end

  self.x = nextX
  self.y = nextY
end

function Bullet:cleanIfUnused ()
  -- clean bullet when it is out of visible world bounds
  local x, y, width, height = self.camera:getVisible()

  if self.x > x + width or self.x < x or self.y > y + height or self.y < y then
    self:destroy()
  end
end

return Bullet

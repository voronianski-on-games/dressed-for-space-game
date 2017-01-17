local lume = require('vendor/lume')
local _ = require('src/common')
local Entity = require('src/entities/entity')

local bullet1Image, bullet2Image
local bullets = {}

local Bullet = Entity:extend()

Bullet.drawOrder = 1
Bullet.updateOrder = 2

function Bullet.loadAssets ()
  bullet1Image = love.graphics.newImage('assets/images/bullet1.png')
  bullet2Image = love.graphics.newImage('assets/images/bullet2.png')

  bullets.default = {image = bullet1Image}
  bullets.longball = {image = bullet2Image}
end

function Bullet:new (data)
  local bulletType = data.typeName or 'default'
  local bullet = bullets[bulletType]

  Bullet.super.new(self, lume.extend(data, {
    kind = 'bullet',
    image = bullet.image
  }))

  self.targetKind = data.targetKind or 'enemy'
  self.maxSpeed = data.maxSpeed or 500
end

function Bullet:collisionFilter (other)
  if self:isTarget(other, 'enemy') or
     self:isTarget(other, 'player')
  then
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

    if self:isTarget(other, 'enemy') then
      self:destroy()
      other:damage()
    end

    if self:isTarget(other, 'player') then
      self:destroy()
      other:die()
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

function Bullet:isTarget (value, kind)
  return self.targetKind == kind and value.kind == kind
end

return Bullet

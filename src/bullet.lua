local lume = require('vendor/lume')
local _ = require('src/common')
local Entity = require('src/entity')

local bulletImage = nil
local bulletSpeed = 500
local bulletScale = 0.6

local Bullet = Entity:extend()

Bullet.drawOrder = 1
Bullet.updateOrder = 2

function Bullet.loadAssets ()
  bulletImage = love.graphics.newImage('assets/bullet.png')
end

function Bullet:new (data)
  Bullet.super.new(self, lume.extend(data, {
    width = bulletImage:getWidth(),
    height = bulletImage:getHeight()
  }))
end

function Bullet:collisionFilter (item, other)
  -- if other:is(Player) then
  return false
end

function Bullet:update (dt)
  local futureX = self.x + math.cos(self.rotation) * bulletSpeed * dt
  local futureY = self.y + math.sin(self.rotation) * bulletSpeed * dt
  local nextX, nextY, collisions, len = self.world:move(self, futureX, futureY, self.collisionFilter)

  for i = 1, len do
    print(collisions[i])
  end

  self.x = nextX
  self.y = nextY

  -- clean bullets when they are out of visible world bounds
  local x, y, width, height = self.camera:getVisible()

  if self.x > x + width or self.x < x or self.y > y + height or self.y < y then
    self:destroy()
  end
end

function Bullet:draw ()
  love.graphics.draw(bulletImage, self.x, self.y, self.rotation, bulletScale, bulletScale, self.width / 2, self.height / 2)
end

return Bullet

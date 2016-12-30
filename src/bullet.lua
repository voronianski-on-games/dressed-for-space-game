local lume = require('vendor/lume')
local _ = require('src/common')
local Entity = require('src/entity')

local bulletImage = nil
local bulletSpeed = 500
local bulletScale = 0.6

local Bullet = Entity:extend()

function Bullet.loadAssets ()
  bulletImage = love.graphics.newImage('assets/bullet.png')
end

function Bullet:new (playerData)
  Bullet.super.new(self, lume.extend(playerData, {
    width = bulletImage:getWidth(),
    height = bulletImage:getHeight()
  }))
end

function Bullet:filter (other)

end

function Bullet:update (dt)
  local futureX = self.x + math.cos(self.rotation) * bulletSpeed * dt
  local futureY = self.y + math.sin(self.rotation) * bulletSpeed * dt
  local nextX, nextY, collisions, len = self.world:move(self, futureX, futureY)

  for i = 1, len do
    print(collisions[i])
  end

  self.x = nextX
  self.y = nextY

  -- clean bullets when they are out of world bounds
  -- local x, y, width, height = self.camera:getVisible()

  -- if self.x > width or self.x < x or self.y > height or self.y < y then
  --   self:destroy()
  -- end
  if self.x > _.WORLD_WIDTH or self.x < _.WORLD_ORIGIN_X or self.y > _.WORLD_HEIGHT or self.y < _.WORLD_ORIGIN_Y then
    self:destroy()
  end
end

function Bullet:draw ()
  love.graphics.draw(bulletImage, self.x, self.y, self.rotation, bulletScale, bulletScale, self.width / 2, self.height / 2)
end

return Bullet

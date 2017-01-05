local Object = require('vendor/object')

local Entity = Object:extend()

function Entity:new (data)
  data = data or {}

  self.world = data.world
  self.camera = data.camera
  self.image = data.image
  self.width = data.width or self.image:getWidth()
  self.height = data.height or self.image:getHeight()

  self.x = data.x or 0
  self.y = data.y or 0
  self.xvel = data.xvel or 0
  self.yvel = data.yvel or 0
  self.xscale = data.scale or data.xscale or 1
  self.yscale = data.scale or data.yscale or 1
  self.rotation = data.rotation or 0
  self.kind = data.kind or 'entity'

  self.world:add(self, self.x, self.y, self.width, self.height)
  self.createdAt = love.timer.getTime()
end

function Entity:destroy ()
  self.world:remove(self)
end

function Entity:getDrawOrder ()
  return self.drawOrder or self.createdAt
end

function Entity:getUpdateOrder ()
  return self.updateOrder or 10000
end

function Entity:getCenter ()
  local ox = self.width / 2
  local oy = self.height / 2

  return {
    x = self.x + ox,
    y = self.y + oy,
    ox = ox,
    oy = oy
  }
end

function Entity:draw ()
  local center = self:getCenter()

  love.graphics.draw(
    self.image,
    center.x, center.y,
    self.rotation,
    self.xscale, self.yscale,
    center.ox, center.oy
  )
end

function Entity:drawBounds ()
  local center = self:getCenter()

  love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
  love.graphics.rectangle('line', center.x, center.y, self.width, self.height)
end

return Entity

local Object = require('vendor/object')
local lume = require('vendor/lume')
local _ = require('src/common')

local Entity = Object:extend()

function Entity:new (data)
  data = data or {}

  self.id = lume.uuid()
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

-- infinite world bounds for entity
function Entity:checkWorldBounds ( ... )
  local minX = -self.width / 2
  local minY = -self.height / 2
  local maxX = _.WORLD_WIDTH + self.width / 2
  local maxY = _.WORLD_HEIGHT + self.height / 2

  if self.x < minX then
    self.x = maxX
  elseif self.x > maxX then
    self.x = minX
  end

  if self.y < minY then
    self.y = maxY
  elseif self.y > maxY then
    self.y = minY
  end
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

-- used in debug only
function Entity:drawBounds (lx, ly)
  local center = self:getCenter()

  love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
  love.graphics.rectangle('line', center.x, center.y, self.width, self.height)

  if self.approachRadius then
    love.graphics.circle('line', center.x, center.y, self.approachRadius)
  end
end

return Entity

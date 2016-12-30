local Object = require('vendor/object')

local Entity = Object:extend()

function Entity:new (data)
  data = data or {}

  self.world = data.world
  self.camera = data.camera
  self.width = data.width
  self.height = data.height

  self.x = data.x or 0
  self.y = data.y or 0
  self.xvel = data.xvel or 0
  self.yvel = data.yvel or 0
  self.rotation = data.rotation or 0

  self.world:add(self, self.x, self.y, self.width, self.height)
  self.createdAt = love.timer.getTime()
end

function Entity:destroy ()
  self.world:remove(self)
end

return Entity

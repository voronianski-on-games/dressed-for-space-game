local bump = require('vendor/bump')
local Object = require('vendor/object')
local _ = require('src/common')
local Player = require('src/entities/player')
local Enemy = require('src/entities/enemy')

local Map = Object:extend()

function Map:new (camera)
  self.camera = camera
end

function Map:reset ()
  self.x = _.WORLD_ORIGIN_X
  self.y = _.WORLD_ORIGIN_Y
  self.width = _.WORLD_WIDTH
  self.height = _.WORLD_HEIGHT

  self.world = bump.newWorld()

  self.player = Player({
    x = self.width / 2,
    y = self.height / 2,
    world = self.world,
    camera = self.camera
  })

  -- enemies positions should be generated
  Enemy({
    x = 1200,
    y = 1200,
    player = self.player,
    world = self.world,
    camera = self.camera
  })
end

function Map:update (dt, x, y, width, height)
  -- update only visible
  local x = x or self.x
  local y = y or self.y
  local width = width or self.width
  local height = height or self.height
  local visibles, len = self.world:queryRect(x, y, width, height)

  table.sort(visibles, _.sortByUpdateOrder)

  for i = 1, len do
    local entity = visibles[i]

    entity:update(dt)
  end
end

function Map:draw (x, y, width, height)
  local visibles, len = self.world:queryRect(x, y, width, height)

  table.sort(visibles, _.sortByDrawOrder)

  for i = 1, len do
    local entity = visibles[i]

    entity:draw(x, y, width, height)

    if _.debugEntities then
      entity:drawBounds(x, y, width, height)
    end
  end
end

function Map:countItems()
  return self.world:countItems()
end

return Map

local lume = require('vendor/lume')
local anim8 = require('vendor/anim8')
local _ = require('src/common')
local Entity = require('src/entities/entity')

local gem3Image = nil
local gems = {}

local Gem = Entity:extend()

function Gem.loadAssets ()
  gem3Image = love.graphics.newImage('assets/gem3.png')

  gems.orange = {
    width = 20,
    height = 20,
    image = gem3Image,
    lifeTime = 60
  }

  local g3 = anim8.newGrid(
    gems.orange.width,
    gems.orange.height,
    gem3Image:getWidth(),
    gem3Image:getHeight()
  )
  gems.orange.animation = anim8.newAnimation(g3('1-4', 1), 0.12)
end

function Gem:new (data)
  local gemType = data.gemType or 'orange'
  local gem = gems[gemType]

  Gem.super.new(self, lume.extend(data, {
    kind = 'gem',
    image = gem3Image
  }))

  self.lived = 0
  self.lifeTime = gem.lifeTime -- lifetime in seconds
  self.animation = gem.animation
end

function Gem:update (dt)
  self.lived = self.lived + dt

  if self.lived >= self.lifeTime then
    self:destroy()
  else
    self.animation:update(dt)
  end
end

function Gem:draw ()
  local center = self:getCenter()

  self.animation:draw(
    self.image,
    center.x, center.y,
    self.rotation,
    self.xscale, self.yscale,
    center.ox, center.oy
  )
end

return Gem

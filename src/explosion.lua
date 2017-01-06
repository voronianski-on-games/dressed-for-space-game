local lume = require('vendor/lume')
local anim8 = require('vendor/anim8')
local _ = require('src/common')
local Entity = require('src/entity')

local explosionImage = nil
local animation = nil

local Explosion = Entity:extend()

function Explosion.loadAssets ()
  explosionImage = love.graphics.newImage('assets/fx7.png')

  local grid = anim8.newGrid(82, 72, explosionImage:getWidth(), explosionImage:getHeight())

  animation = anim8.newAnimation(grid('1-8', 1), 0.1)
end

function Explosion:new (data)
  Explosion.super.new(self, lume.extend(data, {
    kind = 'explosion',
    image = explosionImage,
    width = 72,
    height = 72
  }))

  self.lived = 0
  self.lifeTime = 0.1 + math.random() -- lifetime in seconds
end

function Explosion:update (dt)
  self.lived = self.lived + dt

  if self.lived >= self.lifeTime then
    self:destroy()
  else
    animation:update(dt)
  end
end

function Explosion:draw ()
  local center = self:getCenter()

  animation:draw(
    self.image,
    center.x, center.y,
    self.rotation,
    self.xscale, self.yscale,
    center.ox, center.oy
  )
end

return Explosion

local lume = require('vendor/lume')
local anim8 = require('vendor/anim8')
local _ = require('src/common')
local Entity = require('src/enteties/entity')

local fx1Image, fx7Image
local effects = {}

local Explosion = Entity:extend()

function Explosion.loadAssets ()
  fx1Image = love.graphics.newImage('assets/fx1.png')
  fx7Image = love.graphics.newImage('assets/fx7.png')

  effects.fx1 = {
    width = 38,
    height = 38,
    image = fx1Image,
    lifeTime = 0.6
  }
  effects.fx7 = {
    width = 82,
    height = 72,
    image = fx7Image,
    lifeTime = 0.8
  }

  local g1 = anim8.newGrid(
    effects.fx1.width,
    effects.fx1.height,
    fx1Image:getWidth(),
    fx1Image:getHeight()
  )
  local g7 = anim8.newGrid(
    effects.fx7.width,
    effects.fx7.height,
    fx7Image:getWidth(),
    fx7Image:getHeight()
  )

  effects.fx1.animation = anim8.newAnimation(g1('1-6', 1), 0.1)
  effects.fx7.animation = anim8.newAnimation(g7('1-8', 1), 0.1)
end

function Explosion:new (data)
  local effectName = data.effectName or 'fx7'
  local effect = effects[effectName]

  Explosion.super.new(self, lume.extend(data, {
    kind = 'explosion',
    image = effect.image,
    width = effect.width,
    height = effect.height
  }))

  self.lived = 0
  self.lifeTime = effect.lifeTime -- lifetime in seconds
  self.animation = effect.animation
end

function Explosion:update (dt)
  self.lived = self.lived + dt

  if self.lived >= self.lifeTime then
    self:destroy()
  else
    self.animation:update(dt)
  end
end

function Explosion:draw ()
  local center = self:getCenter()

  self.animation:draw(
    self.image,
    center.x, center.y,
    self.rotation,
    self.xscale, self.yscale,
    center.ox, center.oy
  )
end

return Explosion

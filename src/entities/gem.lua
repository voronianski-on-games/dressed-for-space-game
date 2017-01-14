local lume = require('vendor/lume')
local anim8 = require('vendor/anim8')
local _ = require('src/common')
local Entity = require('src/entities/entity')

local gem1Image, gem2Image, gem3Image, gem4Image
local gemSound = nil
local gems = {}

local Gem = Entity:extend()

Gem.drawOrder = 1
Gem.updateOrder = -1

function Gem.loadAssets ()
  gemSound = love.audio.newSource('assets/sounds/gold1.wav', 'static')

  gem1Image = love.graphics.newImage('assets/images/gem1.png')
  gem2Image = love.graphics.newImage('assets/images/gem2.png')
  gem3Image = love.graphics.newImage('assets/images/gem3.png')
  gem4Image = love.graphics.newImage('assets/images/gem4.png')

  gems.ruby = {
    width = 16,
    height = 20,
    image = gem1Image,
    lifeTime = 10
  }
  gems.star = {
    width = 21,
    height = 21,
    image = gem2Image,
    lifeTime = 20
  }
  gems.gold = {
    width = 20,
    height = 20,
    image = gem3Image,
    lifeTime = 30
  }
  gems.jade = {
    width = 15,
    height = 15,
    image = gem4Image,
    lifeTime = 40
  }

  local g1 = anim8.newGrid(
    gems.ruby.width,
    gems.ruby.height,
    gems.ruby.image:getWidth(),
    gems.ruby.image:getHeight()
  )
  local g2 = anim8.newGrid(
    gems.star.width,
    gems.star.height,
    gems.star.image:getWidth(),
    gems.star.image:getHeight()
  )
  local g3 = anim8.newGrid(
    gems.gold.width,
    gems.gold.height,
    gems.gold.image:getWidth(),
    gems.gold.image:getHeight()
  )
  local g4 = anim8.newGrid(
    gems.jade.width,
    gems.jade.height,
    gems.jade.image:getWidth(),
    gems.jade.image:getHeight()
  )

  gems.ruby.animation = anim8.newAnimation(g1('1-4', 1), 0.12)
  gems.star.animation = anim8.newAnimation(g2('1-4', 1), 0.12)
  gems.gold.animation = anim8.newAnimation(g3('1-4', 1), 0.12)
  gems.jade.animation = anim8.newAnimation(g4('1-4', 1), 0.12)
end

function Gem:new (data)
  local gemType = data.typeName or 'gold'
  local gem = gems[gemType]

  Gem.super.new(self, lume.extend(data, {
    kind = 'gem',
    image = gem.image,
    width = gem.width,
    height = gem.height
  }))

  self.lived = 0
  self.lifeTime = gem.lifeTime -- lifetime in seconds
  self.animation = gem.animation
  self.points = love.math.random(10, 50)
  self.angleAcceleration = lume.randomchoice({-2, 2})
  self.xvel = lume.randomchoice({-5, 5})
  self.yvel = lume.randomchoice({-5, 5})
end

function Gem:update (dt)
  self.lived = self.lived + dt

  if self.lived >= self.lifeTime then
    self:destroy()
  else
    self.animation:update(dt)
    self:rotate(dt)
    self:move(dt)
  end
end

function Gem:rotate (dt)
  self.rotation = self.rotation + self.angleAcceleration * dt
end

function Gem:move (dt)
  local futureX = self.x + self.xvel * dt
  local futureY = self.y + self.yvel * dt
  local nextX, nextY = self.world:move(self, futureX, futureY)

  self.x = nextX
  self.y = nextY
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

function Gem:pick ()
  gemSound:play()
  self:destroy()
end

return Gem

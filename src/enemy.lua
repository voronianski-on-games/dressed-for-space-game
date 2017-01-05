local lume = require('vendor/lume')
local _ = require('src/common')
local Entity = require('src/entity')

local enemyImage = nil

local Enemy = Entity:extend()

function Enemy.loadAssets ()
  enemyImage = love.graphics.newImage('assets/enemy.png')
end

function Enemy:new (data)
  Enemy.super.new(self, lume.extend(data, {
    kind = 'enemy',
    image = enemyImage,
    width = 36,
    height = 36
  }))
end

function Enemy:update (dt)
  self:move(dt)
end

function Enemy:draw ()
  local center = self:getCenter()

  love.graphics.draw(
    self.image,
    center.x, center.y,
    self.rotation,
    self.xscale, self.yscale,
    center.ox + 6, center.oy + 14
  )
end

function Enemy:collisionFilter ()
end

function Enemy:move (dt)
  local futureX = self.x + self.xvel * dt
  local futureY = self.y + self.yvel * dt
  local nextX, nextY, collisions, len = self.world:move(self, futureX, futureY, self.collisionFilter)

  self.x = nextX
  self.y = nextY
  self.xvel = self.xvel * 0.99
  self.yvel = self.yvel * 0.99
end

return Enemy

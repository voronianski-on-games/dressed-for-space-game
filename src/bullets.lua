local lume = require('vendor/lume')
local _ = require('src/common')
local space = require('src/space')

local bullet = {}

local bulletImage = nil
local bulletSpeed = 500
local bulletScale = 0.6
local bulletList = {}

function bullet.loadAssets ()
  bulletImage = love.graphics.newImage('assets/bullet.png')
end

function bullet.create (player)
  local bullet = {
    id = lume.uuid(),
    x = player.x,
    y = player.y,
    width = bulletImage:getWidth(),
    height = bulletImage:getHeight(),
    rotation = player.rotation,
    createdAt = love.timer.getTime()
  }
  space.world:add(bullet, bullet.x, bullet.y, bullet.width, bullet.height)
  table.insert(bulletList, bullet)
end

function bullet.updata (dt)
  bullets.each(function (bullet, index)
    bullet.x = bullet.x + math.cos(bullet.rotation) * bulletSpeed * dt
    bullet.y = bullet.y + math.sin(bullet.rotation) * bulletSpeed * dt

    -- clean bullets when they are out of world bounds
    if bullet.x > _.WORLD_WIDTH or bullet.x < _.WORLD_ORIGIN_X or
       bullet.y > _.WORLD_HEIGHT or bullet.y < _.WORLD_ORIGIN_Y then
       bullets.remove(index)
    end
  end)
end

function bullet.remove (index)
  space.world.remove
  table.remove(bulletList, index)
end

function bullets.each (cb)
  for i, bullet in ipairs(bulletList) do
    cb(bullet, i, bulletList)
  end
end

function bullets.draw (playerRotation)
  bullets.each(function (bullet)
    love.graphics.draw(bulletImage, bullet.x, bullet.y, bullet.rotation, bulletScale, bulletScale, bullet.width / 2, bullet.height / 2)
  end)
end

function bullets.count ()
  return #bulletList
end

return bullets

local lume = require('vendor/lume')
local _ = require('src/common')

local bullets = {}

local bulletImage = nil
local bulletSpeed = 500
local bulletScale = 0.6
local bulletList = {}

function bullets.loadAssets ()
  bulletImage = love.graphics.newImage('assets/bullet.png')
end

function bullets.create (player)
  table.insert(bulletList, {
    id = lume.uuid(),
    x = player.x,
    y = player.y,
    width = bulletImage:getWidth(),
    height = bulletImage:getHeight(),
    rotation = player.rotation
  })
end

function bullets.reset ()
  bulletList = {}
end

function bullets.move (dt)
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

function bullets.remove (index)
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

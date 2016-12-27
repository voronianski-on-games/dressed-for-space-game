local bullets = {}

local bulletImg = nil
local bulletSpeed = 300
local bulletList = {}

function bullets.loadAssets ()
  bulletImg = love.graphics.newImage('assets/bullet.png')
end

function bullets.create (player)
  table.insert(bulletList, {
    x = player.x, -- + (player.img:getWidth() / 2),
    y = player.y,
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
    love.graphics.draw(bulletImg, bullet.x, bullet.y, bullet.rotation, 0.6, 0.6, bulletImg:getWidth() / 2, bulletImg:getHeight() / 2)
  end)
end

return bullets

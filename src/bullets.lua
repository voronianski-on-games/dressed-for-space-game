local bullets = {}

local bulletImg = nil
local bulletSpeed = 200
local bulletList = {}

function bullets.loadAssets ()
  bulletImg = love.graphics.newImage('assets/bullet.png')
end

function bullets.create (player)
  local angle = math.rad(player.rotation)

  print('angle %s', angle)

  table.insert(bulletList, {
    x = player.x, -- + (player.img:getWidth() / 2),
    y = player.y,
    xvel = player.xvel + math.cos(angle) * bulletSpeed,
    yvel = player.yvel + math.sin(angle) * bulletSpeed,
    rotation = player.rotation
  })
end

function bullets.reset ()
  bulletList = {}
end

function bullets.update (dt, player)
  bullets.each(function (bullet, index)
    -- print(player.rotation, math.cos(player.rotation), math.sin(player.rotation))
    -- bullet.x = bullet.x + (bulletSpeed * dt)
    -- bullet.y = bullet.y + (bulletSpeed * dt)
    -- print(bullet.x, player.xvel, dt, (player.xvel * dt))
    bullet.x = bullet.x + bullet.xvel * dt
    bullet.y = bullet.y + bullet.yvel * dt
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

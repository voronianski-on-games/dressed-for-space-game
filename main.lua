local ANGLE_ACCELERATION = 6 -- angles per second
local ACCELERATION = 100

local player = {
  x = 150,
  y = 150,
  xvel = 0,
  yvel = 0,
  img = nil,
  speed = 300, -- pixels per second
  rotation = -1.6
}

function love.load ()
  player.img = love.graphics.newImage('player.png')
end

function love.update (dt)
  if love.keyboard.isDown('lcmd') and love.keyboard.isDown('q') then
    love.event.push('quit')
  end

  if love.keyboard.isDown('right') then
    player.rotation = player.rotation + ANGLE_ACCELERATION*dt
  end

  if love.keyboard.isDown('left') then
    player.rotation = player.rotation - ANGLE_ACCELERATION*dt
  end

  if love.keyboard.isDown('down') then
    player.xvel = player.xvel - ACCELERATION*dt * math.cos(player.rotation)
    player.yvel = player.yvel - ACCELERATION*dt * math.sin(player.rotation)
  end

  if love.keyboard.isDown('up') then
    player.xvel = player.xvel + ACCELERATION*dt * math.cos(player.rotation)
    player.yvel = player.yvel + ACCELERATION*dt * math.sin(player.rotation)
  end

  player.x = player.x + player.xvel*dt
  player.y = player.y + player.yvel*dt
  player.xvel = player.xvel * 0.99
  player.yvel = player.yvel * 0.99
end

function love.draw ()
  love.graphics.draw(
    player.img,
    player.x,
    player.y,
    player.rotation,
    1,
    1,
    player.img:getWidth()/2,
    player.img:getHeight()/2
  )
end

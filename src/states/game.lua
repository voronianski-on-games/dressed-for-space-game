local _ = require('src/common')
local Map = require('src/map')
local Camera = require('src/camera')
local media = require('src/media')
local shaders = require('src/shaders')

local game = {}

local camera, map

function game:init ()
  camera = Camera()
  map = Map(camera)
end

function game:enter ()
  map:reset()
end

function game:update (dt)
  -- update elements that are visible to the camera and not far away from radius
  local x, y, width, height = camera:getVisible()

  x = x - _.UPDATE_RADIUS
  y = y - _.UPDATE_RADIUS
  width = width + _.UPDATE_RADIUS * 2
  height = height + _.UPDATE_RADIUS * 2

  map:update(dt, x, y, width, height)
  camera:setPosition(map.player.x, map.player.y)
  camera:update(dt)
end

function game:draw ()
  shaders.postEffect():draw(function ()
    camera:draw(function (x, y, width, height)
      media.drawBackgroundImage()
      map:draw(x, y, width, height)
    end)

    if _.debug then
      local ww, wh = love.graphics.getDimensions()
      local stats = ('fps: %d, mem: %dKB, items: %d, points: %d'):format(
        love.timer.getFPS(),
        collectgarbage('count'),
        map:countItems(),
        map.player.points
      )

      love.graphics.setFont(media.imageFontLowercase)
      love.graphics.print(stats, 5, wh - 20)
    end
  end)
end

return game

local _ = require('src/common')
local Timer = require('vendor/timer')
local media = require('src/media')
local shaders = require('src/shaders')

local title, desc, buttons
local menu = {}

function menu:init ()
  title = {text = 'DRESSED FOR SPACE'}
  desc = {
    text = 'are you ready to join the road to ruin?',
    x = 0,
    y = 160
  }
end

function menu:enter ()
  local ww, wh = love.graphics.getDimensions()

  title.x = ww / 2 - 260
  title.y = -60

  Timer.tween(2, title, {y = 120}, 'in-bounce')
end

function menu:leave ()
end

function menu:update (dt)
  Timer.update(dt)
end

function menu:draw ()
  -- shaders.postEffectBlurry():draw(function ()
  --   media.drawMenuBackgroundImage()
  -- end)

  shaders.postEffect():draw(function ()
    love.graphics.setFont(media.imageFontTitle)
    love.graphics.print(title.text, title.x, title.y)
    love.graphics.setFont(media.imageFontLowercase)
    love.graphics.printf(desc.text, desc.x, desc.y, 640, 'center')
  end)
end

return menu

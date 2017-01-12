local _ = require('src/common')
local Timer = require('vendor/timer')
local media = require('src/media')
local shaders = require('src/shaders')

local menu = {}
local title = {text = 'DRESSED FOR SPACE'}

function menu:init ()

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
  shaders.postEffect():draw(function ()
    -- shaders.postEffectBlurry():draw(function ()
    --   media.drawBackgroundImage()
    -- end)

    love.graphics.setFont(media.imageFontTitle)
    love.graphics.print(title.text, title.x, title.y)
  end)
end

return menu

local _ = require('src/common')
local Timer = require('vendor/timer')
local media = require('src/media')
local shaders = require('src/shaders')

local menu = {}
local title = nil

function menu:init ()

end

function menu:enter ()
  local ww, wh = love.graphics.getDimensions()

  title = {
    x = ww / 2 - 260,
    y = -60,
    text = 'DRESSED FOR SPACE'
  }

  Timer.tween(5, title, {y = 100}, 'in-bounce')
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

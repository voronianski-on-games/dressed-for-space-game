local media = require('src/media')
local shaders = require('src/shaders')

local menu = {}

function menu:init ()

end

function menu:update (dt)

end

function menu:draw ()
  local ww, wh = love.graphics.getDimensions()

  shaders.postEffect():draw(function ()
    shaders.postEffectBlurry():draw(function ()
      media.drawBackgroundImage()
    end)

    love.graphics.setFont(media.imageFontTitle)
    love.graphics.print('DRESSED FOR SPACE', ww / 2 - 260, 100)
  end)
end

return menu

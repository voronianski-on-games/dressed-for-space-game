local media = require('src/media')

local menu = {}

function menu:init ()

end

function menu:update (dt)

end

function menu:draw ()
  local ww, wh = love.graphics.getDimensions()

  love.graphics.setFont(media.imageFontTitle)
  love.graphics.print('DRESSED FOR SPACE', ww / 2 - 260, 100)
end

return menu

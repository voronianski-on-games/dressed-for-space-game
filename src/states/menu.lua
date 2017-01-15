local lume = require('vendor/lume')
local _ = require('src/common')
local Timer = require('vendor/timer')
local media = require('src/media')
local shaders = require('src/shaders')

local title, desc, buttons
local menu = {}

function menu:init ()
  local ww, wh = love.graphics.getDimensions()

  title = {
    text = 'DRESSED FOR SPACE',
    x = 0,
    y = -60
  }

  desc = {
    text = 'are you ready to join the road to ruin?',
    x = 0,
    y = 560
  }

  buttons = {
    {text = 'start', x = 0, y = 220},
    {text = 'settings', x = 0, y = 240},
    {text = 'exit', x = 0, y = 260}
  }
end

function menu:enter ()
  Timer.tween(2, title, {y = 120}, 'in-bounce', function ()
    -- lume.each(buttons, function (button)
    --   Timer.tween(2, button, {y = 220}, 'in-cubic')
    --   Timer.tween(2, button, {y = 240}, 'in-cubic')
    --   Timer.tween(2, button, {y = 260}, 'in-cubic')
    -- end)
  end)
end

function menu:update (dt)
  Timer.update(dt)
end

function menu:draw ()
  shaders.postEffect():draw(function ()
    love.graphics.setFont(media.imageFontTitle)
    love.graphics.printf(title.text, title.x, title.y, 640, 'center')

    love.graphics.setFont(media.imageFontLowercase)
    -- love.graphics.printf(desc.text, desc.x, desc.y, 640, 'center')

    -- lume.each(buttons, function (button)
    --   love.graphics.printf(button.text, button.x, button.y, 640, 'center')
    -- end)
  end)
end

return menu

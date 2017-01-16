local lume = require('vendor/lume')
local _ = require('src/common')
local Timer = require('vendor/timer')
local media = require('src/media')
local shaders = require('src/shaders')

local title, desc, introSound

local menu = {}

function menu:init ()
  local ww, wh = love.graphics.getDimensions()

  title = {
    text = 'DRESSED FOR SPACE',
    x = 0,
    y = -20,
    ready = false
  }

  desc = {
    -- text = 'are you ready to join the road to ruin?',
    text = 'press "enter" to start',
    x = 0,
    y = 250,
    visible = true,
    time = 0.6,
    counter = 0
  }

  introSound = love.audio.newSource('assets/sounds/ice_climber.wav', 'static');
end

function menu:enter ()
  introSound:play()
  Timer.tween(2, title, {y = 150}, 'linear', function ()
    title.ready = true
  end)
end

function menu:update (dt)
  Timer.update(dt)

  -- if title.ready then
  --   desc.counter = desc.counter + dt
  --   if desc.counter >= desc.time then
  --     desc.counter = 0
  --     desc.visible = not desc.visible
  --   end
  -- end
end

function menu:draw ()
  shaders.postEffect():draw(function ()
    love.graphics.setFont(media.imageFontTitle)
    love.graphics.printf(title.text, title.x, title.y, 640, 'center')

    love.graphics.setFont(media.imageFontLowercase)
    if title.ready then
      if desc.visible then
        love.graphics.printf(desc.text, desc.x, desc.y, 640, 'center')
      end
    end
  end)
end

return menu

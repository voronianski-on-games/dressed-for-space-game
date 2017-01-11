local Gamestate = require('vendor/gamestate')
local Player = require('src/entities/player')
local Bullet = require('src/entities/bullet')
local Enemy = require('src/entities/enemy')
local Explosion = require('src/entities/explosion')
local media = require('src/media')
local shaders = require('src/shaders')
local menu = require('src/states/menu')
local game = require('src/states/game')


function love.load ()
  love.mouse.setVisible(false)

  shaders.load()
  media.loadImageFonts()
  media.loadBackgroundImage()
  media.playBackgroundPlaylist()

  Player.loadAssets()
  Bullet.loadAssets()
  Enemy.loadAssets()
  Explosion.loadAssets()

  Gamestate.registerEvents()
  Gamestate.switch(game)
end

function love.keypressed (key)
  if key == 'lcmd' and key == 'q' then
    love.event.push('quit')
  end

  if key == 'escape' then
    if Gamestate.current() ~= menu then
      Gamestate.switch(menu)
    else
      Gamestate.switch(game)
    end
  end
end

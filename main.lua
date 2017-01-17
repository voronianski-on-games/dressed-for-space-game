local Gamestate = require('vendor/gamestate')
local Player = require('src/entities/player')
local Bullet = require('src/entities/bullet')
local Enemy = require('src/entities/enemy')
local Explosion = require('src/entities/explosion')
local Gem = require('src/entities/gem')
local media = require('src/media')
local shaders = require('src/shaders')
local menu = require('src/states/menu')
local game = require('src/states/game')


function love.load ()
  love.mouse.setVisible(false)

  shaders.load()

  media.loadImageFonts()
  media.loadBackgroundImages()
  media.loadBackgroundPlaylist()

  Player.loadAssets()
  Bullet.loadAssets()
  Enemy.loadAssets()
  Explosion.loadAssets()
  Gem.loadAssets()

  Gamestate.registerEvents()
  Gamestate.switch(menu)
end

function love.keypressed (key)
  if key == 'lcmd' and key == 'q' then
    love.event.push('quit')
  end

  if key == 'return' then
    if Gamestate.current() ~= menu then
      Gamestate.switch(menu)
    else
      Gamestate.switch(game)
    end
  end
end

local Gamestate = require('vendor/gamestate')
local Player = require('src/enteties/player')
local Bullet = require('src/enteties/bullet')
local Enemy = require('src/enteties/enemy')
local Explosion = require('src/enteties/explosion')
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

  if key == 'esc' then
    print('show menu here')
  end
end

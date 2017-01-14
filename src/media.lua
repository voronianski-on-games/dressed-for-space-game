local _ = require('src/common')

local media = {}
local gameBgImage, gameBgQuad
local menuBgImage, menuBgQuad
local bgSong

function media.loadBackgroundImages ()
  gameBgImage = love.graphics.newImage('assets/images/bg1.png')
  gameBgImage:setWrap('repeat', 'repeat')
  gameBgQuad = love.graphics.newQuad(
    _.WORLD_ORIGIN_X,
    _.WORLD_ORIGIN_Y,
    _.WORLD_WIDTH,
    _.WORLD_HEIGHT,
    gameBgImage:getWidth(),
    gameBgImage:getHeight()
  )

  menuBgImage = love.graphics.newImage('assets/images/bg2.png')
  menuBgImage:setWrap('repeat', 'repeat')
  menuBgQuad = love.graphics.newQuad(
    _.WORLD_ORIGIN_X,
    _.WORLD_ORIGIN_Y,
    _.WORLD_WIDTH,
    _.WORLD_HEIGHT,
    menuBgImage:getWidth(),
    menuBgImage:getHeight()
  )
end

function media.playBackgroundPlaylist ()
  -- TBD: more songs in background
  bgSong = love.audio.newSource('assets/music/uoki_toki-king_of_my_castle.mp3', 'static')
  -- bgSong:play()
end

function media.loadImageFonts ()
  media.imageFont = love.graphics.newImageFont(
    'assets/images/imagefont.png',
    ' abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`\'*#=[]"'
  )
  media.imageFontTitle = love.graphics.newImageFont(
    'assets/images/imagefont_title.png',
    ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
  )
  media.imageFontLowercase = love.graphics.newImageFont(
    'assets/images/imagefont_lowercase.png',
    ' abcdefghijklmnopqrstuvwxyz[/]^_/0123456789:;<=!"#$%&\'()*+,-.>?@'
  )
end

function media.drawGameBackgroundImage ()
  love.graphics.draw(gameBgImage, gameBgQuad, 0, 0)
end

function media.drawMenuBackgroundImage ()
  love.graphics.draw(menuBgImage, menuBgQuad, 0, 0)
end

return media

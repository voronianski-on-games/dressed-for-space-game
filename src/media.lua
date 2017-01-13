local _ = require('src/common')

local media = {}
local bgImage, bgQuad, bgSong, imageFont

function media.loadBackgroundImage ()
  bgImage = love.graphics.newImage('assets/images/bg1.png')
  bgImage:setWrap('repeat', 'repeat')

  bgQuad = love.graphics.newQuad(
    _.WORLD_ORIGIN_X,
    _.WORLD_ORIGIN_Y,
    _.WORLD_WIDTH,
    _.WORLD_HEIGHT,
    bgImage:getWidth(),
    bgImage:getHeight()
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

function media.drawBackgroundImage ()
  love.graphics.draw(bgImage, bgQuad, 0, 0)
end

return media

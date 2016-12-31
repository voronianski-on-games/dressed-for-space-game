local _ = require('src/common')
local Gamera = require('vendor/gamera')
local Shakycam = require('vendor/shakycam')

function Camera ()
  local gamera = Gamera.new(_.WORLD_ORIGIN_X, _.WORLD_ORIGIN_Y, _.WORLD_WIDTH, _.WORLD_HEIGHT)
  local shakycam = Shakycam.new(gamera)

  return shakycam
end

return Camera

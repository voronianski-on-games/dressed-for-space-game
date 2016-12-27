local shine = require('vendor/shine')

local shaders = {}
local postEffect

function shaders.load ()
  local grain = shine.filmgrain({opacity = 0.1})
  local pixelate = shine.pixelate({pixel_size = 1.1})
  local scanlines = shine.scanlines({opacity = 0.3})
  local vignette = shine.vignette({radius = 0.9, opacity = 0.3})

  postEffect = vignette:chain(grain):chain(pixelate):chain(scanlines)
end

function shaders.postEffect ()
  return postEffect
end

return shaders

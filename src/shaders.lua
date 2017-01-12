local shine = require('vendor/shine')

local shaders = {}
local postEffect = nil
local postEffectBlurry = nil

function shaders.load ()
  local grain = shine.filmgrain({opacity = 0.1})
  local pixelate = shine.pixelate({pixel_size = 1.1})
  local scanlines = shine.scanlines({opacity = 0.3})
  local vignette = shine.vignette({radius = 0.9, opacity = 0.3})

  postEffect = vignette:chain(grain):chain(pixelate):chain(scanlines)
  postEffectBlurry = shine.boxblur({radius = 3.8})
end

function shaders.postEffect ()
  return postEffect
end

function shaders.postEffectBlurry ()
  return postEffectBlurry
end

return shaders

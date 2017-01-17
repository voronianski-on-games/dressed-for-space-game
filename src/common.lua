local inspect = require('vendor/inspect')

local _ = {
  -- disable in production
  debug = true,
  debugEntities = true,

  WORLD_ORIGIN_X = 0,
  WORLD_ORIGIN_Y = 0,
  WORLD_WIDTH = 3000,
  WORLD_HEIGHT = 3000,
  UPDATE_RADIUS = 300 -- how "far away from the camera" things stop being updated
}

function _.sortByDrawOrder (a, b)
  return a:getDrawOrder() < b:getDrawOrder()
end

function _.sortByUpdateOrder (a, b)
  return a:getUpdateOrder() < b:getUpdateOrder()
end

function _.getImageScaleForDimensions (image, newWidth, newHeight)
  local width = image:getWidth()
  local height = image:getHeight()

  return {
    x = newWidth / width,
    y = newHeight / height
  }
end

function _.getVectorLength (x, y)
  return math.sqrt(x * x + y * y)
end

function _.normalizeVector (x, y)
  local len = _.getVectorLength(x, y)

  return {
    x = x / len,
    y = y / len
  }
end

function _.noop ()
end

function _.inspect (...)
  print(inspect(...))
end

-- global shorthand in development
if _.debug then
  _G.inspect = _.inspect
end

return _

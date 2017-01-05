local _ = {
  -- disable in production
  debug = true,
  debugEntities = true,

  WORLD_ORIGIN_X = 0,
  WORLD_ORIGIN_Y = 0,
  WORLD_WIDTH = 3000,
  WORLD_HEIGHT = 3000,
  UPDATE_RADIUS = 100 -- how "far away from the camera" things stop being updated
}

-- mutating object
function _.checkWorldBounds (obj)
  local minX = -obj.width / 2
  local minY = -obj.height / 2
  local maxX = _.WORLD_WIDTH + obj.width / 2
  local maxY = _.WORLD_HEIGHT + obj.height / 2

  if obj.x < minX then
    obj.x = maxX
  elseif obj.x > maxX then
    obj.x = minX
  end

  if obj.y < minY then
    obj.y = maxY
  elseif obj.y > maxY then
    obj.y = minY
  end
end

function _.sortByDrawOrder (a, b)
  return a:getDrawOrder() < b:getDrawOrder()
end

function _.sortByUpdateOrder (a, b)
  return a:getUpdateOrder() < b:getUpdateOrder()
end

return _

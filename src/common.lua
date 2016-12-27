local _ = {
  debug = true, -- remove in production
  WORLD_ORIGIN_X = 0,
  WORLD_ORIGIN_Y = 0,
  WORLD_WIDTH = 2000,
  WORLD_HEIGHT = 2000
}

-- mutating object
function _.checkWorldBounds (obj, width, height)
  local minX = -width / 2
  local minY = -height / 2
  local maxX = _.WORLD_WIDTH + width / 2
  local maxY = _.WORLD_HEIGHT + height / 2

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

return _

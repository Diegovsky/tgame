--- @class Vec2
local Vec2 = {}

function Vec2.new(a, b)
  return setmetatable({a, b or a}, {__index=Vec2, __tostring=function(self)
    return ("(%d, %d)"):format(self[1], self[2])
  end})
end

function Vec2:add(a1, b1)
  self[1] = self[1] + a1
  self[2] = self[2] + b1
end

function Vec2:set(a1, b1)
  self[1] = a1
  self[2] = b1 or a1
end

function Vec2:translate(other)
  self[1] = other[1] + self[1]
  self[2] = other[2] + self[2]
  return self
end

function Vec2:scale(m)
  self[1] = self[1] * m
  self[2] = self[2] * m
  return self
end

function Vec2:clone()
  return Vec2.new(self[1], self[2])
end

function Vec2:apply(map)
  self[1] = map(self[1], 1)
  self[2] = map(self[2], 2)
  return self
end

return Vec2

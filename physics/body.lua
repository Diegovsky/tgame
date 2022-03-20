--- @class Body
--- @field pos Vec2
--- @field res Vec2
--- @field vel Vec2
--- @field acc Vec2
--- @field friction Vec2
local M = {}
local Vec2 = require'physics.vec2'

--- @return Body
function M.new(x, y, width, height)
  return setmetatable({id='Body',
                       pos=Vec2.new(x, y),
                       res=Vec2.new(width, height),
                       vel=Vec2.new(0, 0),
                       acc=Vec2.new(0, 0),
                       friction=Vec2.new(0, 0)

  }, {__index=M})
end

function M:intercepts(other)
  local inner = function(index)
    return math.abs(self.pos[index] - other.pos[index]) <= math.max(self.res[index], other.res[index])
  end
  return inner(0) and inner(1)
end

function M:update(dt)
  self.vel:translate(self.acc:clone():scale(dt))
  self.pos:translate(self.vel:clone():scale(dt))
  self.vel:apply(function(val, i) return val  - (dt * val * (1 - self.friction[i])) end)
end

return M

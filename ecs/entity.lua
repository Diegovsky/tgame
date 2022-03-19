--- @class Entity
--- @field eid string
--- @field components table[string, Component]
local Entity = {}

function Entity.new()
  return setmetatable({ components = {} }, { __index = Entity })
end

--- @param comp Component
--- @return Entity
function Entity:add(comp)
  self.components[comp.id] = comp
  return self
end

return Entity

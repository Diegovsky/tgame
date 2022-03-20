--- @class Entity
--- @field eid string
--- @field components table[string, Component]
local Entity = {}

function Entity.new()
  return setmetatable({ components = {}, id='Entity' }, { __index = Entity })
end

--- @param comp Component|string
--- @param data table|nil
--- @return Entity
function Entity:add(comp, data)
  if data and type(comp) == 'string' then
    data.id = comp
    self.components[comp] = data
  else
    self.components[comp.id] = comp
  end
  return self
end

return Entity

local Registry = require("utils").Registry
require "ecs.entity"

---@class World
--- @field entities Entity[]
--- @field systems table<string, System>
--- @field component_reg table<string, Component[]>
local World = {}

--- @class System
--- @field id string
--- @field action fun(World, Component)
--- @field target_id string
local System = {}
function System.new(id, target, action)
  return { id = id, target_id = target, action = action }
end

World.System = System

--- @class Component
--- @field id string
--- @field eid string
local _decl1

--- @return World
function World.new()
  return setmetatable(
    { entities = Registry(), component_reg = {}, systems = {}, id='World' },
    { __index = World }
  )
end

--- @param system System
function World:add_system(system)
  self.systems[system.id] = system
end
--- @param entity Entity
function World:add(entity)
  local eid = self.entities:add(entity)
  entity.eid = eid
  for _, comp in pairs(entity.components) do
    comp.eid = eid
    if self.component_reg[comp.id] == nil then
      self.component_reg[comp.id] = {}
    end
    self.component_reg[comp.id][eid] = comp
  end
end

function World:get_component(eid, component_id)
  return self.component_reg[component_id][eid]
end

function World:iteration()
  for id, system in pairs(self.systems) do
    local components = self.component_reg[system.target_id]
    if components then
      for _, comp in pairs(components) do
        system.action(self, comp)
      end
    else
      print(id..' not being used')
    end
  end
end

--- Due to the way Love2D works, Drawable is special cased and treated
--- differently from other systems
function World:draw()
  for id, drawable in pairs(self.component_reg.Drawable)
  do
    drawable.draw(self, drawable)
  end
end

return World

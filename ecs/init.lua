local Registry = require("utils").Registry
require "ecs.entity"

---@class World
--- @field entities Entity[]
--- @field systems table<string, System>
--- @field draw_systems table<string, System>
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
    { entities = Registry(),
      component_reg = {
        ['None'] = {{}}
      },
      systems = {},
      draw_systems = {},
      info = {dt = 0},
      id='World'
    },
    { __index = World }
  )
end

--- @param system System
function World:add_system(system)
  self.systems[system.id] = system
end

--- @param system System
function World:add_draw_system(system)
  self.draw_systems[system.id] = system
end
--- @param entity Entity
function World:add(entity)
  if entity.id ~= 'Entity'
  then
    error("Expected Entity instance, got "..getid(entity))
  end
  local eid = self.entities:add(entity)
  entity.eid = eid
  for _, comp in pairs(entity.components) do
    assert(isobj(comp), ('Expected Component in slot %s, found %s'):format(_, getid(comp)))
    comp.eid = eid
    if self.component_reg[comp.id] == nil then
      self.component_reg[comp.id] = {}
    end
    self.component_reg[comp.id][eid] = comp
  end
end

function World:get_component(eid, component_id)
  return assert(self.component_reg[component_id], 'Component '..component_id..' not found')[eid]
end

function World:iteration(systems)
  for id, system in pairs(systems) do
    local components = self.component_reg[system.target_id]
    if components then
      system.unused = false
      for _, comp in pairs(components) do
        system.action(self, comp)
      end
    else
      if not system.unused
      then
        print(id..' not being used')
        system.unused = true
      end
    end
  end
end

function World:update(dt)
  self.info.dt = dt
  self:iteration(self.systems)
end

--- Due to the way Love2D works, a system that draws is special
--- cased and treated differently from other systems.
function World:draw()
  -- self.info.dt = nil
  self:iteration(self.draw_systems)
end

return World

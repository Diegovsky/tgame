local M = {}

local System = require("ecs").System

M.Gravity = System.new("Gravity", "Weighted", function(world, obj)
  local pos = world:get_component(obj.eid, "Position")
  pos.y = pos.y + 1
end)

M.Controller = System.new("Controller", "Controllable", function(world, ctrl)
  local pos = world:get_component(ctrl.eid, "Position")
  local velx = 0
  local vely = 0
  if love.keyboard.isDown "w" then
    vely = -1 + vely
  end
  if love.keyboard.isDown "s" then
    vely = 1 + vely
  end
  if love.keyboard.isDown "a" then
    velx = -1 + velx
  end
  if love.keyboard.isDown "d" then
    velx = 1 + velx
  end
  pos.x = pos.x + velx
  pos.y = pos.y + vely
  local clamp = function(n, min, max)
    return math.min(math.max(n, min), max)
  end
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  pos.x = clamp(pos.x, 0, width - 100)
  pos.y = clamp(pos.y, 0, height - 100)
end)

return M

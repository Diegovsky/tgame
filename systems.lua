local M = {}

local System = require("ecs").System

M.BodyPhysics = System.new('BodyPhysics', 'Body', function (world, body)
  body:update(world.info.dt)
end)

return M

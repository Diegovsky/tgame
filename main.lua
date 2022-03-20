local utils = require "utils"
SCREEN_STACK = require "screen"

local System = require("ecs").System
local World = require "ecs"
local Entity = require("ecs.entity").new()

function isobj(obj)
  if type(obj) == 'table' and obj.id
  then
    return true
  else
    return false
  end
end

function getid(obj)
  if isobj(obj) then
    return obj.id
  else
    return type(obj)
  end
end

function love.load()
  require'utils.load_hooks'.loadhooks()

  local world = World.new()
  for _, system in pairs(require "systems") do
    world:add_system(system)
  end
  world:add(require'plants.peashooter'.new(0, 0))
  world:add(require'plants.peashooter'.new(0, 1))
  world:add(require'plants.peashooter'.new(1, 1))
  world:add(require'plants.peashooter'.new(2, 1))
  world:add_draw_system({id='FPSCounter', target_id='None', action=function (world, self)
    local now = 1/world.info.dt
    love.graphics.printf(('FPS: %d'):format(now), 10, 10, 100)
  end})

  local Dbg = {
    id='Debug',
    target_id='None',
    action=function (world, body)
    end
  }

  world:add_system(Dbg)

  SCREEN_STACK:push {
    update = function(dt)
      world:update(dt)
    end,
    draw = function() world:draw() end,
  }
end

function love.update(dt)
  SCREEN_STACK:update(dt)
end

function love.draw()
  SCREEN_STACK:draw()
end

function love.keypressed(key, scancode, isrepeat)
  SCREEN_STACK:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
  SCREEN_STACK:keyreleased(key, scancode)
end

function love.mousepressed(x, y, button, istouch, presses)
  SCREEN_STACK:mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
  SCREEN_STACK:mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
  SCREEN_STACK:mousemoved(x, y, dx, dy, istouch)
end

function love.textinput(text)
  SCREEN_STACK:textinput(text)
end

function love.wheelmoved(x, y)
  SCREEN_STACK:wheelmoved(x, y)
end

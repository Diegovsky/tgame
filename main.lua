local utils = require "utils"
SCREEN_STACK = require "screen"

local System = require("ecs").System
local World = require "ecs"
local Entity = require("ecs.entity").new()

function love.load()
  utils.loadhooks()

  local world = World.new()
  for _, system in pairs(require "systems") do
    world:add_system(system)
  end
  world:add(require "player")

  world:add_system {
    id='Debug',
    target_id='Position',
    action=function (world, pos)
      -- print(pos.x ..' '.. pos.y)
    end
  }

  SCREEN_STACK:push {
    update = function()
      world:iteration()
    end,
    draw = function() world:draw() end,
  }
end

function love.update(t)
  SCREEN_STACK:update()
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

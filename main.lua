local utils = require'utils'
---@type Pmon
local Pmon, Atk = unpack(require'Pmon')
SCREEN_STACK = require'screen'

function love.load()
  require'ui'
  local create_pmon = require'create_pmon'
  local show_pmon = require'show_pmon'
  for _, cb in ipairs(utils.loadhooks()) do
    cb()
  end
  SCREEN_STACK:push(show_pmon:new(Pmon.new('gabriel', nil, {
    Atk.new('d1', 10, 20),
    Atk.new('d2', 10, 20),
    Atk.new('d3', 10, 20),
    Atk.new('d4', 10, 20),
  })))
end

function love.update()
  SCREEN_STACK:peek():update()
end

function love.draw()
  SCREEN_STACK:peek():draw()
end


function love.keypressed(key, scancode, isrepeat)
  SCREEN_STACK:peek():keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
  SCREEN_STACK:peek():keyreleased(key, scancode)
end

function love.mousepressed(x, y, button, istouch, presses)
  SCREEN_STACK:peek():mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
  SCREEN_STACK:peek():mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
  SCREEN_STACK:peek():mousemoved(x, y, dx, dy, istouch)
end

function love.textinput(text)
  SCREEN_STACK:peek():textinput(text)
end

function love.wheelmoved(x, y)
  SCREEN_STACK:peek():wheelmoved(x, y)
end

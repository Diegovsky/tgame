local utils = require'utils'
local Pmon, Atk = require'Pmon'
local ScreenStack = require'screen'

function love.load()
  require'ui'
  local create_pmon = require'create_pmon'
  for _, cb in ipairs(utils.loadhooks()) do
    cb()
  end
  ScreenStack:push(create_pmon)
end

function love.update()
  ScreenStack:peek():update()
end

function love.draw()
  ScreenStack:peek():draw()
end


function love.keypressed(key, scancode, isrepeat)
  ScreenStack:peek():keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
  ScreenStack:peek():keyreleased(key, scancode)
end

function love.mousepressed(x, y, button, istouch, presses)
  ScreenStack:peek():mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
  ScreenStack:peek():mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
  ScreenStack:peek():mousemoved(x, y, dx, dy, istouch)
end

function love.textinput(text)
  ScreenStack:peek():textinput(text)
end

function love.wheelmoved(x, y)
  ScreenStack:peek():wheelmoved(x, y)
end

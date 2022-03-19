local utils = require "utils"
--- @class ScreenStack
--- @field stack Screen[]
local M = {
  stack = utils.Registry(),
  _counter = 0,
}

--- @class Screen
--- @field stack ScreenStack
--- @field draw fun()
--- @field update love.update
--- @field keypressed love.keypressed
--- @field keyreleased love.keyreleased
--- @field mousepressed love.mousepressed
--- @field mousereleased love.mousereleased
--- @field mousemoved love.mousemoved
--- @field textinput love.textinput
--- @field wheelmoved love.wheelmoved
local _

M.fields = {
  'load';
  'keypressed';
  'keyreleased';
  'mousepressed';
  'mousereleased';
  'mousemoved';
  'textinput';
  'wheelmoved'
}

local function patch(screen)
  for _, name in ipairs(M.fields) do
    if screen[name] == nil then
      screen[name] = function () end
    end
  end
  return screen
end

--- Pushes a new screen onto the stack
--- @param screen Screen
function M:push(screen)
  assert(type(screen) == 'table', 'Expected table.')
  local mt = getmetatable(screen)
  if mt == nil
  then
    mt = {}
    setmetatable(screen, mt)
  end
  self.stack:add(patch(screen))
  if M._counter >= 100000 then
    error('Max screens limit reached')
  end
end

--- Removes the last stack frame
--- @return Screen
function M:pop(tok)
  return self.stack:rm(tok)
end

function M:delegate(name, ...)
  for _, screen in self.stack:iter()
  do
    local f = screen[name]
    if f then
      f(...)
    end
  end
end

-- Love functions

function M:update(t)
  self:delegate('update', t)
end

function M:draw()
  self:delegate('draw')
end

function M:keypressed(key, scancode, isrepeat)
  self:delegate('keypressed', key, scancode, isrepeat)
end

function M:keyreleased(key, scancode)
  self:delegate('keyreleased', key, scancode)
end

function M:mousepressed(x, y, button, istouch, presses)
  self:delegate('mousepressed', x, y, button, istouch, presses)
end

function M:mousereleased(x, y, button, istouch, presses)
  self:delegate('mousereleased', x, y, button, istouch, presses)
end

function M:mousemoved(x, y, dx, dy, istouch)
  self:delegate('mousemoved', x, y, dx, dy, istouch)
end

function M:textinput(text)
  self:delegate('textinput', text)
end

function M:wheelmoved(x, y)
  self:delegate('wheelmoved', x, y)
end

return M

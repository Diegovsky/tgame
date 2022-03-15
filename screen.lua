--- @class ScreenStack
--- @field stack Screen[]
local M = {
  stack = {}
}

--- @class Screen
--- @field stack ScreenStack
--- @field draw fun()
--- @field update love.update
--- @field load fun()
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
--- Pushes a new screen onto the stack
--- @param screen Screen
function M:push(screen)
  screen.stack = self
  for _, name in ipairs(self.fields) do
    if screen[name] == nil then
      print('Overriding', name)
      screen[name] = function () end
    end
  end
  table.insert(self.stack, screen)
end

--- Returns the current stack frame
--- @return Screen
function M:peek()
  return self.stack[#self.stack] or love.event.quit()
end

--- Removes the last stack frame
--- @return Screen
function M:pop()
  return table.remove(self.stack)
end

return M

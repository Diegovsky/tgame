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

local function patch(screen)
  for _, name in ipairs(M.fields) do
    if screen[name] == nil then
      screen[name] = function () end
    end
  end
  return screen
end

local NOOP_SCREEN = patch({
  update = function ()
   love.event.quit(0)
  end,
  draw = function () end
})

--- Pushes a new screen onto the stack
--- @param screen Screen
function M:push(screen)
  table.insert(self.stack, patch(screen))
end

function M:exec(newscreen)
  self.stack[#self.stack] = patch(newscreen)
end

--- Returns the current stack frame
--- @return Screen
function M:peek()
  return self.stack[#self.stack] or NOOP_SCREEN
end

--- Removes the last stack frame
--- @return Screen
function M:pop()
  return table.remove(self.stack)
end

return M

local nuk = require'nuklear'
local ScreenStack = require'screen'

local M = {}
local ui = nuk.newUI()

--- @class UIScreen : Screen
--- @field ui any
local _

---Wraps a screen with UI context
---@param screen any
function M.new(screen)
  screen.ui = ui
  for _, methodname in ipairs(ScreenStack.fields)do
    screen[methodname] = function(self, ...) return self.ui[methodname](self.ui, ...) end
  end
  return screen
end

return M

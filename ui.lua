local nuk = require'nuklear'
local ScreenStack = require'screen'

local M = {}
local ui = nuk.newUI()


--- @class UIScreen : Screen
--- @field ui any
--- @field popups fun(number)[]
local UIScreen = {}

---Wraps a screen with UI context
---@param screen any
---@return UIScreen
function M.new(screen)
  screen.ui = ui
  for _, methodname in ipairs(ScreenStack.fields)do
    screen[methodname] = function(self, ...) return self.ui[methodname](self.ui, ...) end
  end
  screen.popups = {}
  screen._counter = 0
  return setmetatable(screen, {__index = UIScreen})
end

function UIScreen:add(type_, c)
  if not c then
    error("Expected first argument to not be nil")
  end
  local tk = self._counter
  self._counter = self._counter + 1
  self.popups[tk] = {tk, c, type_}
end

function UIScreen:rm(token)
  self.popups[token] = nil
end

function UIScreen:show(type_)
  for _, item in pairs(self.popups) do
    if item[3] == type_ then
      item[2](item[1])
    end
  end
end

function UIScreen:showwindows()
  self:show('window')
end

function UIScreen:showpopups()
  self:show('popup')
end

function UIScreen:popup(title, label)
  local ui = self.ui
  return function(tok)
    if ui:popupBegin('dynamic', title, 80, 100, 300, 200, 'closable', 'title', 'scrollbar', 'movable') then
      ui:layoutRow('dynamic', 40, 1)
      ui:label(label)
      ui:popupEnd()
    else
      self:rm(tok)
    end
  end
end

return M

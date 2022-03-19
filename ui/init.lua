local nuk = require'nuklear'
local ScreenStack = require'screen'

local M = {}
local ui = nuk.newUI()


--- @class UIScreen : Screen
--- @field ui any
--- @field draw_ui fun()
--- @field children WindowChildren
local UIScreen = {}
for _, methodname in ipairs(ScreenStack.fields)do
  UIScreen[methodname] = function(self, ...) return self.ui[methodname](self.ui, ...) end
end

--- Wraps a screen with UI context
--- @param screen any
--- @return UIScreen
function M.new(screen)
  screen.ui = ui
  screen.popups = {}
  screen._counter = 0
  screen.children = require'ui.children'.new()
  return setmetatable(screen, {__index = UIScreen})
end

function UIScreen:window(title, x, y, width, height, body)
  if ui:windowBegin(title, x, y, width, height, 'title', 'scrollbar',
    'movable') then
    body()
    self.children:showpopups()
    ui:windowEnd()
    self.children:showwindows()
  end
end

function UIScreen:update(t)
  ui:frameBegin()
  self:draw_ui()
  ui:frameEnd()
end

function UIScreen:draw()
  self.ui:draw()
end

function UIScreen:popup(title, label)
  return function(tok)
    if ui:popupBegin('dynamic', title, 80, 100, 300, 200, 'closable', 'title',
      'scrollbar', 'movable') then
      ui:layoutRow('dynamic', 40, 1)
      ui:label(label)
      ui:popupEnd()
    else
      self.children:rm(tok)
    end
  end
end

return M

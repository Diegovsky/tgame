--- @class DebugUI : UIScreen
local DebugUI = require'ui'.new({})

function DebugUI.new()
  return setmetatable({}, {__index=DebugUI})
end

local uisize = 20

function DebugUI:draw_ui()
  local ui = self.ui
  self:window('Hello, world', 20, 30, 150, 300, function ()
    ui:layoutRow('dynamic', uisize, 1)
    ui:label('ola')
    if ui:button('press') then
      print('e')
    end
  end)
end

return DebugUI


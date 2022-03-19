local Pmon, Atk = unpack(require "Pmon")

---@class PmonScreen : UIScreen
---@field pmon Pmon
local screen = require("ui").new { atkc = 0 }

local uisize = 30

function screen:draw_ui()
  local ui = self.ui
  self:window(self.pmon.name, 100, 80, 300, 300, function()
    local img = self.pmon:image()
    local width, height = img:getPixelDimensions()
    ui:layoutRow('dynamic', height, 2)
    ui:image(img)
    ui:label(self.pmon.name)
    for _, atk in ipairs(self.pmon.atks) do
      ui:layoutRow('dynamic', uisize*4, 1)
      if ui:groupBegin(atk.name, 'border', 'title') then
        ui:layoutRow('dynamic', uisize, 2)
        ui:label('SP:')
        ui:label(atk.sp)

        ui:layoutRow('dynamic', uisize, 2)
        ui:label('Damage:')
        ui:label(atk.dmg)
        ui:groupEnd()
      end
    end
  end)
end

function screen:new(pmon)
  self.pmon = pmon
  return self
end

return screen

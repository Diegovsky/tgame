local Pmon, Atk = unpack(require "Pmon")

---@class PmonScreen : UIScreen
---@field pmon Pmon
local screen = require("ui").new { atkc = 0 }

local uisize = 30

function screen:update()
  local ui = self.ui
  ui:frameBegin()
  if ui:windowBegin(self.pmon.name, 100, 80, 300, 300, 'border', 'title', 'movable', 'scrollbar') then
    local img = self.pmon:image()
    local width, height = img:getPixelDimensions()
    img:
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
  end
  ui:windowEnd()
  ui:frameEnd()
end

function screen:draw()
  self.ui:draw()
end

function screen:new(pmon)
  self.pmon = pmon
  return self
end

return screen

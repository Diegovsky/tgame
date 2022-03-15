local utils = require'utils'
local nuk = require'nuklear'
local ui = require'ui'.ui

local Pmon, Atk = require'Pmon'

local function wrapper(self)
  if self == nil then
    return nil
  end
  return function(_otherself, ...)
    return self(ui, ...) 
  end
end

--- @type Screen
local screen = require'ui'.new({})

local name = {value=''}
local imgurl = {value=''}
local uisize = 30

local atkc = 0
function screen:attackwin(atklist)
  local ui = self.ui
  local atkname = {value=''}
  local dmg = {value=''}
  local sp  = {value=''}
  atkc = atkc + 1
  if atkc > 4 then
    local normal = "Can only do 4 attacks"
    local schizo = ("I hate gabriel penis "):rep(100)
    ui:popup('dynamic', 'Warning', 0, 0, 300, 200, 'closable', 'title', function()
      ui:label(atkc == 4 and normal or schizo)
    end)
    return
  end
  local winname = 'atkwin'..tostring(atkc)
  return function ()
    ui:window(winname, 'Create Attack', 100, 100, 200, 160, 'border', 'movable', 'title', function ()
      ui:layoutRow('dynamic', uisize, 2)
      ui:label("Attack name:")
      ui:edit('simple',atkname)
      ui:layoutRow('dynamic', uisize, 2)
      ui:label("Damage")
      ui:edit('simple', dmg)
      ui:layoutRow('dynamic', uisize, 2)
      ui:label("SP")
      ui:edit('simple', sp)
      ui:layoutrow('dynamic', uisize, 1)
      if ui:button('Done') then
        ui:windowClose(winname)
        table.insert(atklist, Atk.new(name.value, dmg.value, sp.value))
      end
      end)
  end
end

function screen:update(dt)
  local ui = self.ui
  ui:frameBegin()
  if ui:windowBegin('Simple Example', 100, 100, 200, 160,
    'border', 'title', 'movable') then
    ui:layoutRow('dynamic', uisize, 2)
    ui:label('Name:')
    ui:edit('simple', name)
    ui:label('Image:')
    ui:edit('simple', name)
  end
  ui:windowEnd()
  ui:frameEnd()
end

function screen:draw()
  self.ui:draw()
end

return screen

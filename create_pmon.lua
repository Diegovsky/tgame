local Pmon, Atk = unpack(require "Pmon")

--- @type UIScreen
local screen = require("ui").new { atkc = 4 }

local name = { value = "" }
local imgurl = { value = "" }
local uisize = 30
--- @type table<number,Atk>
local atks = {0, 0, 0, 0}

function screen:attackwin(atklist)
  local ui = self.ui
  local atkname = { value = "" }
  local dmg = { value = "" }
  local sp = { value = "" }
  self.atkc = self.atkc + 1
  if self.atkc > 4 then
    local normal = "Can only do 4 attacks"
    local schizo = ("I hate gabriel penis"):rep(2, " "):rep(10, "\n")
    self.children:addpopup(self:popup("Warning", self.atkc == 4 and normal or schizo))
    return
  end
  local atkc = self.atkc
  local winname = tostring(self.atkc) .. "atk"
  self.children:addwindow(function(tok)
    if
      ui:windowBegin(
        winname,
        "Create Attack Number " .. tostring(atkc),
        80,
        100,
        200,
        180,
        "border",
        "movable",
        "title"
      )
    then
      ui:layoutRow("dynamic", uisize, 2)
      ui:label "Attack name:"
      ui:edit("simple", atkname)
      ui:layoutRow("dynamic", uisize, 2)
      ui:label "Damage"
      ui:edit("simple", dmg)
      ui:layoutRow("dynamic", uisize, 2)
      ui:label "SP"
      ui:edit("simple", sp)
      ui:layoutRow("dynamic", uisize, 1)
      if ui:button "Done" then
        if #atkname.value ~= 0 and #dmg.value ~= 0 and #sp.value ~= 0 then
          local atk = Atk.new(atkname.value, dmg.value, sp.value)
          if atk then
            ui:windowClose(winname)
            atklist[atkc] = atk
            self.children:rm(tok)
          else
            self.children:addpopup(self:popup("Invalid number", "A field is wrong, dingus"))
          end
        end
      end
      ui:windowEnd()
    end
  end)
end

function screen:draw_ui()
  local ui = self.ui
  self:window("Pokemon add screen", 100, 100, 300, 360, function()
    ui:layoutRow("dynamic", uisize, 2)
    ui:label "Name:"
    ui:edit("simple", name)
    ui:layoutRow("dynamic", uisize, 3)
    ui:label "Image:"
    ui:edit("simple", imgurl)
    if ui:button "Upload image" then
      local path = require("osutils").openfile(".", "image")
      if path ~= nil then
        imgurl.value = path
      end
    end
    if ui:button "Add Attack" then
      self:attackwin(atks)
    end
    for i, atk in pairs(atks) do
      ui:layoutRow("dynamic", uisize, 2)
      ui:label(("Attack %d:"):format(i))
      -- ui:label(atk.name)
    end
    if #atks == 4 then
      if ui:button "Finish!" then
        SCREEN_STACK:exec(require'show_pmon':new(Pmon.new(name.value, imgurl.value, atks)))
      end
    end
  end)
end

return screen

local utils = require'utils'

--- @class Pmon
--- @field name string
--- @field imgurl string
--- @field atks Atk[]
local M = {
}

local imagecache = {}

--- @class Atk
--- @field name string
--- @field dmg number
--- @field sp number
local Atk = {}

function Atk.new(name, dmg, sp)
  dmg = tonumber(dmg)
  sp = tonumber(sp)
  if not dmg or not sp then
    return nil
  end
  return {name=name, dmg=dmg, sp=sp}
end



---@param name string
---@param imageurl string
---@param atks Atk[]
function M.new(name, imageurl, atks)
  return setmetatable({name=name, imgurl=imageurl, atks=atks or {}}, {__index=M})
end

function M:image()
  local img = imagecache[self.imgurl]
  if img == nil then
    print('loading image ', self.imgurl)
    img = love.graphics.newImage(self.imgurl)
    imagecache[self.imgurl] = img
  end
  return img
end

local packfmt = "s s" .. string.rep("s j j", 4)

function M:pack()
  local function unpackatks(i)
    if i == 5 then
      return
    end
    return self.atks[i].name, self.atks[i].dmg, self.atks[i].sp, unpackatks(i+1)
  end
  return love.data.pack('data', packfmt, self.name, self.imgurl, unpackatks(0))
end

function M.load(data)
  local items = {love.data.unpack(packfmt, data)}
  local pmon = M.new(table.remove(items, 1), table.remove(items, 1))
  for i=1,4,1 do
    table.insert(pmon.atks, Atk.new(items[i + 1], items[i + 2], items[i + 3]))
  end
  return pmon
end

return {M, Atk}

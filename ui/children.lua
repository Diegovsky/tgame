
--- @class WindowChildren
--- @field popups fun(number)[]
local WindowChildren = {}

function WindowChildren.new()
  return setmetatable({_counter=0, popups={}}, {__index=WindowChildren})
end

function WindowChildren:add(type_, c)
  if not c then
    error("Expected first argument to not be nil")
  end
  local tk = self._counter
  self._counter = self._counter + 1
  self.popups[tk] = {tk, c, type_}
end

function WindowChildren:addwindow(c)
  return self:add('window', c)
end

function WindowChildren:addpopup(c)
  return self:add('popup', c)
end

function WindowChildren:rm(token)
  self.popups[token] = nil
end

function WindowChildren:show(type_)
  for _, item in pairs(self.popups) do
    if item[3] == type_ then
      item[2](item[1])
    end
  end
end

function WindowChildren:showwindows()
  self:show('window')
end

function WindowChildren:showpopups()
  self:show('popup')
end

return WindowChildren

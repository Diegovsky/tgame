--- A screen that wraps around 2 screens.
--- @class ConsScreen
--- @field car Screen
--- @field cdr Screen
local ConsScreen = {}


function ConsScreen.new(car, cdr)
  return setmetatable({car=car, cdr=cdr}, {__index=ConsScreen.delegate})
end

function call(obj, name, ...)
  if obj[name] then
    obj[name](obj, ...)
    return true
  else
    return false
  end
end

function ConsScreen:delegate(fname)
  return function(_self, ...)
    call(self.car, fname, ...)
    call(self.cdr, fname, ...)
  end
end

return ConsScreen

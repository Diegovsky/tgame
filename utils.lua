local loadhooks = {}
local M = {}
function M.addloadhook(cb)
  table.insert(loadhooks, cb)
end
function M.loadhooks()
  for _, cb in ipairs(loadhooks) do
    cb()
  end
end
function M.contains_val(arr, el)
  for _, val in ipairs(arr) do
    if el == val then
      return true
    end
  end
  return false
end

function M.Registry()
  return ({
    _counter=0,
    dict={},
    add=function(self, obj)
      self.dict[self._counter] = obj
      self._counter = self._counter + 1
      return self._counter - 1
    end,
    get=function(self, id)
      return self.dict[id]
    end,
    iter=function (self)
      return pairs(self.dict)
    end,
    rm=function(self, id)
      self.dict[id] = nil
    end
  })
end

return M


local loadhooks = {}
local M = {}
function M.addloadhook(cb)
  table.insert(loadhooks, cb)
end
function M.loadhooks()
  return loadhooks
end
function M.contains_val(arr, el)
  for _, val in ipairs(arr) do
    if el == val then
      return true
    end
  end
  return false
end
return M

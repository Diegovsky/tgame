local M = {}
local loadhooks = {}

function M.addloadhook(cb)
  table.insert(loadhooks, cb)
end

function M.loadhooks()
  for _, cb in ipairs(loadhooks) do
    cb()
  end
end

return M

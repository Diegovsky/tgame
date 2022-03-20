local M = {}
local imagecache = {}
local DEFAULT_IMAGE = 'assets/default.png'

require'utils.load_hooks'.addloadhook(function ()
  imagecache[DEFAULT_IMAGE] = love.graphics.newImage(DEFAULT_IMAGE)
end)


function M.image(url)
  if url == nil then
    return imagecache[DEFAULT_IMAGE]
  end
  local img = imagecache[url]
  if img == nil then
    print('loading image ', url)
    img = love.graphics.newImage(url)
    imagecache[url] = img
  end
  return img
end

return M

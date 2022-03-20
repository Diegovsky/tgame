local Vec2 = require "physics.vec2"
local Peashooter = {}

function Peashooter.new(line, col)
  return require'ecs.entity'.new()
  :add('Position', Vec2.new(line, col))
  :add('Drawable', {draw=function(world, self)
    --- @type Vec2
    local lane = world:get_component(self.eid, 'Position')
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    local spritewidth = width/8
    local spriteheight = height/5
    local img = require'utils'.image()
    love.graphics.draw(img, spritewidth*lane[1], spriteheight*lane[2], 0, 1, 1)
  end})
 end

return Peashooter

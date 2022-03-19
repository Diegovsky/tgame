local Entity = require("ecs.entity").new()

local Player = Entity.new()
  :add({ id = "Position", x = 0, y = 0 })
  :add({ id = "Weighted" })
  :add({
    id = "Drawable",
    draw = function(world, self)
      local pos = world:get_component(self.eid, "Position")
      local oldcolor = { love.graphics.getColor() }
      love.graphics.setColor(0.8, 0.8, 0.2, 1.0)
      love.graphics.rectangle("fill", pos.x, pos.y, 100, 100)
      love.graphics.setColor(unpack(oldcolor))
    end,
  })
  :add { id = "Controllable" }

return Player

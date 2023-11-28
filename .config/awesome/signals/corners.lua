-- Required libraries
local gears = require("gears")

-- Rounded corners
client.connect_signal("manage", function(c)
    c.shape = function(cr, w, h)
        if not c.fullscreen then
            gears.shape.rounded_rect(cr, w, h, 12)
        else
            gears.shape.rectangle(cr, w, h)
        end
    end
end)

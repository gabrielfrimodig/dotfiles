-- Required libraries
local gears = require("gears")

-- This function is triggered whenever a new client (window) is managed in AwesomeWM.
-- It sets the shape of the client window. For regular (non-fullscreen) windows,
-- it applies rounded corners using the gears.shape.rounded_rect function,
-- which creates a rectangle with rounded edges. The radius of the rounding is set to 12 pixels.
-- If the client is in fullscreen mode, it uses gears.shape.rectangle to keep
-- the standard rectangular shape without rounded corners. This ensures that
-- fullscreen applications like games or videos maintain an edge-to-edge display.
client.connect_signal("manage", function(c)
    c.shape = function(cr, w, h)
        if not c.fullscreen then
            gears.shape.rounded_rect(cr, w, h, 12)
        else
            gears.shape.rectangle(cr, w, h)
        end
    end
end)

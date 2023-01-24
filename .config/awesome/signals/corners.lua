
-- Required libraries
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Rounded corners
-- Doesn't work perfectly on fullscreen
client.connect_signal("manage", function (c)
    c.shape = function(cr,w,h)
        gears.shape.rounded_rect(cr,w,h,12)
    end
end)


-- Required libraries
local awful = require("awful")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

--- Function to create a layoutbox widget for each screen in AwesomeWM.
-- A layoutbox widget is used to display and control the current layout of each screen.
-- Users can change the layout by clicking on the layoutbox widget.
-- Left-click (button 1) cycles through the available layouts in a forward direction.
-- Right-click (button 3) cycles through the layouts in a backward direction.
-- Scroll wheel up (button 4) and down (button 5) are also used for cycling through layouts.
-- @param s The screen for which the layoutbox is being created.
-- @return A layoutbox widget with margins set and configured for the given screen.
return function(s)
    -- Create a layoutbox widget
    local layoutbox = awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({}, 1, function() awful.layout.inc(1) end),
            awful.button({}, 3, function() awful.layout.inc(-1) end),
            awful.button({}, 4, function() awful.layout.inc(-1) end),
            awful.button({}, 5, function() awful.layout.inc(1) end),
        }
    }
    layoutbox = wibox.container.margin(layoutbox, dpi(4), dpi(4), dpi(4), dpi(4))

    return layoutbox
end

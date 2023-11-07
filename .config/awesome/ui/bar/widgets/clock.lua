
-- Required libraries
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful").xresources.apply_dpi

local clock = wibox.widget.textclock("<span>%H:%M</span>")
clock.font = beautiful.font

clock_icon = wibox.widget {
    markup = '<span font="' .. beautiful.font_icon .. '"foreground="'.. beautiful.green ..'">󱑌 </span>',
    widget = wibox.widget.textbox,
}

return wibox.widget {
	clock_icon,
    wibox.widget{
        clock, 
        fg = beautiful.green,
        widget = wibox.container.background
    },
    spacing = dpi(2),
    layout = wibox.layout.fixed.horizontal
}


-- Required libraries
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi

local date = wibox.widget.textclock('<span>%a %d %b</span>')
date.font = "Jetbrains Mono 10"

date_icon = wibox.widget {
    markup = '<span font="' .. beautiful.font_icon .. '"foreground="'.. beautiful.yellow ..'">  </span>',
    widget = wibox.widget.textbox,
}

return wibox.widget {
    date_icon,
    wibox.widget{
        date, 
        fg = beautiful.yellow,
        widget = wibox.container.background
    },
    spacing = dpi(2),
    layout = wibox.layout.fixed.horizontal
}


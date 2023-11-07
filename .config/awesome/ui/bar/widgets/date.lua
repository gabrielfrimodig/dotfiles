
-- Required libraries
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful").xresources.apply_dpi
local awful = require("awful")

local date = wibox.widget.textclock("<span>%a %d %b</span>")
date.font = beautiful.font

date_icon = wibox.widget {
    markup = '<span font="' .. beautiful.font_icon .. '"foreground="'.. beautiful.yellow ..'"> </span>',
    widget = wibox.widget.textbox,
}

local month_calendar = awful.widget.calendar_popup.month({
    start_sunday = true,
    spacing = dpi(10),
    font = beautiful.font,
    long_weekdays = true,
    margin = dpi(10),
    style_month = { padding = dpi(10), border_width = 0, bg_color = beautiful.bg_normal },
    style_header = { border_width = 0, bg_color = beautiful.bg_normal },
    style_weekday = { border_width = 0, bg_color = beautiful.bg_normal },
    style_normal = { border_width = 0, bg_color = beautiful.bg_normal },
    style_focus = { border_width = 0, bg_color = beautiful.yellow, fg_color = beautiful.bg_normal }
})

month_calendar:attach(date, nil, {
    ontop = true,
    placement = function(c, args)
        local geo = args.parent.geometry
        c.x = geo.x
        c.y = geo.y + geo.height
        awful.placement.no_offscreen(c)
    end
})

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

-- Required libraries
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local date = wibox.widget.textclock("<span>%a %d %b</span>")
date.font = beautiful.widget_text
local date_icon = wibox.widget.textbox()
date_icon.font = beautiful.widget_icon
date_icon.text = '󰭦'

local date_widget = wibox.widget {
    {
        date_icon,
        fg = beautiful.fg_date,
        widget = wibox.container.background
    },
    {
        date,
        fg = beautiful.fg_date,
        widget = wibox.container.background
    },
    spacing = dpi(4),
    layout = wibox.layout.fixed.horizontal
}

local month_calendar = awful.widget.calendar_popup.month({
    start_sunday = true,
    spacing = dpi(10),
    font = beautiful.font,
    long_weekdays = true,
    margin = dpi(10),
    style_month = { padding = dpi(10), border_width = dpi(1), bg_color = beautiful.black },
    style_header = { border_width = 0, bg_color = beautiful.black },
    style_weekday = { border_width = 0, bg_color = beautiful.black },
    style_normal = { border_width = 0, bg_color = beautiful.black },
    style_focus = { border_width = 0, bg_color = beautiful.fg_date, fg_color = beautiful.black }
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

return date_widget

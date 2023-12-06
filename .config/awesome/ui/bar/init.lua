-- Required libraries
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local taglist = require("ui.bar.taglist")
local tasklist = require("ui.bar.tasklist")
local layoutbox = require("ui.bar.layoutbox")
local mylayoutbox = wibox.container.margin(layoutbox(s), dpi(4), dpi(4), dpi(4), dpi(4))

local cpu_widget = require("ui.bar.widgets.cpu")
local clock_widget = require("ui.bar.widgets.clock")
local battery_widget = require("ui.bar.widgets.battery")
local wifi_widget = require("ui.bar.widgets.wifi")
local date_widget = require("ui.bar.widgets.date")
local memory_widget = require("ui.bar.widgets.memory")
local volume_widget = require("ui.bar.widgets.volume")
local brightness_widget = require("ui.bar.widgets.brightness")

require("ui.powermenu")
require("ui.popups.mic")

local function barcontainer(widget)
    local container = wibox.widget
        {
            widget,
            left = dpi(2),
            right = dpi(2),
            widget = wibox.container.margin
        }
    local box = wibox.widget {
        {
            container,
            top = dpi(2),
            bottom = dpi(2),
            left = dpi(4),
            right = dpi(4),
            widget = wibox.container.margin
        },
        bg = beautiful.black,
        shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 0) end,
        widget = wibox.container.background
    }
    return wibox.widget {
        box,
        top = dpi(2),
        bottom = dpi(2),
        right = dpi(2),
        left = dpi(2),
        widget = wibox.container.margin
    }
end

local separator = wibox.widget {
    markup = '<span font="' .. beautiful.font .. '">| </span>',
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local systray = wibox.widget {
    visible = true,
    base_size = dpi(30),
    horizontal = true,
    screen = 'primary',
    {
        {
            {
                wibox.widget.systray,
                layout = wibox.layout.fixed.horizontal,
            },
            margins = { top = dpi(2), bottom = dpi(2), left = dpi(6), right = dpi(6) },
            widget = wibox.container.margin,
        },
        shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end,
        bg = beautiful.bg_alt,
        widget = wibox.container.background,
    },
    margins = { top = dpi(6), bottom = dpi(6) },
    widget = wibox.container.margin,
}

local widgetscollection = wibox.widget {
    {
        barcontainer(volume_widget),     -- Volume
        barcontainer(brightness_widget), -- Brightness
        barcontainer(battery_widget),    -- Battery
        barcontainer(cpu_widget),        -- CPU
        barcontainer(memory_widget),     -- RAM
        barcontainer(wifi_widget),       -- Wifi
        barcontainer(date_widget),       -- Calendar
        barcontainer(clock_widget),      -- Time
        spacing = dpi(4),
        layout = wibox.layout.fixed.horizontal,
    },
    margins = { top = dpi(2), bottom = dpi(2), },
    widget = wibox.container.margin,
}

local function get_bar(s)
    s.mywibar = awful.wibar({
        position = "top",
        type = "dock",
        ontop = false,
        stretch = false,
        visible = true,
        height = dpi(36),
        width = s.geometry.width,
        screen = s,
        bg = beautiful.black,
        opacity = 0.85,
    })

    s.mywibar:setup({
        {
            {
                layout = wibox.layout.align.horizontal,
                {
                    barcontainer(taglist(s)),
                    separator,
                    barcontainer(tasklist(s)),
                    layout = wibox.layout.fixed.horizontal,
                },
                nil,
                {
                    widgetscollection,
                    systray,
                    mylayoutbox,
                    layout = wibox.layout.fixed.horizontal,
                },
            },
            left = dpi(5),
            right = dpi(5),
            widget = wibox.container.margin,
        },
        shape  = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 0) end,
        widget = wibox.container.background,
    })
end

screen.connect_signal("request::desktop_decoration", function(s)
    get_bar(s)
end)


-- Required libraries
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local taglist = require 'ui.bar.taglist'
local layoutbox = require 'ui.bar.layoutbox'
mylayoutbox = wibox.container.margin(layoutbox(s), dpi(4), dpi(4), dpi(4), dpi(4))

local brightness = require 'ui.bar.widgets.brightness'
local cpu_widget = require 'ui.bar.widgets.cpu'
local clock_widget = require 'ui.bar.widgets.clock'
local battery_widget = require 'ui.bar.widgets.battery'
local wifi_widget = require 'ui.bar.widgets.wifi'
local date_widget = require 'ui.bar.widgets.date'
local memory_widget = require 'ui.bar.widgets.memory'
local volume_widget = require 'ui.bar.widgets.volume'
local brightness_widget = require 'ui.bar.widgets.brightness'
mylauncher = wibox.container.margin(mylauncher, dpi(2), dpi(2), dpi(2), dpi(2))

local function barcontainer(widget)
    local container = wibox.widget
      {
        widget,
        top = dpi(0),
        bottom = dpi(0),
        left = dpi(2),
        right = dpi(2),
        widget = wibox.container.margin
    }
    local box = wibox.widget{
        {
            container,
            top = dpi(2),
            bottom = dpi(2),
            left = dpi(4),
            right = dpi(4),
            widget = wibox.container.margin
        },
        bg = "#1e1e2e",--colors.container,
        shape = function(cr,w,h) gears.shape.rounded_rect(cr,w,h,0) end,
        widget = wibox.container.background
    }
return wibox.widget{
        box,
        top = dpi(2),
        bottom = dpi(2),
        right = dpi(2),
        left = dpi(2),
        widget = wibox.container.margin
    }
end

local separator = wibox.widget{
    markup = '<span font="' .. "JetBrains Mono 10" .. '">| </span>',
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
			margins = {top = dpi(2), bottom = dpi(2), left = dpi(6), right = dpi(6)},
			widget = wibox.container.margin,
		},
		shape = function(cr,w,h) gears.shape.rounded_rect(cr,w,h,8) end,
		bg = beautiful.bg_alt,
		widget = wibox.container.background,
	},
	margins = {top = dpi(6), bottom = dpi(6)},
	widget = wibox.container.margin,
}

local bar_information = wibox.widget {
	{	
		barcontainer(volume_widget),
		barcontainer(brightness_widget),    -- Brightness
		barcontainer(battery_widget),       -- Battery
		barcontainer(cpu_widget),           -- CPU
		barcontainer(memory_widget),        -- RAM
		barcontainer(wifi_widget),          -- Wifi
		barcontainer(date_widget),          -- Calendar
        barcontainer(clock_widget),         -- Time
		systray,                            -- Systray
		spacing = dpi(4),
		layout = wibox.layout.fixed.horizontal,
	},
	margins = {top = dpi(2), bottom = dpi(2),},
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
		bg = "#1e1e2e",
		opacity = 0.85,
	})
	
	s.mywibar:setup({
		{
			{
				layout = wibox.layout.align.horizontal,
				{ 
					barcontainer(taglist(s)),
					separator,
					spacing = dpi(8),
					layout = wibox.layout.fixed.horizontal,
				},
				nil,
				{
					bar_information,
					mylayoutbox,
					layout = wibox.layout.fixed.horizontal,
				},
			},
			left = dpi(5),
			right = dpi(5),
			widget = wibox.container.margin,
		},
		shape  = function(cr,w,h) gears.shape.rounded_rect(cr, w, h, 0) end,
		widget = wibox.container.background,
	})
end

screen.connect_signal("request::desktop_decoration", function(s)
	get_bar(s)
end)

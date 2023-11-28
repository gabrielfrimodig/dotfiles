-- Required libraries
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local brightness = wibox.widget.textbox()
brightness.font = beautiful.font

local brightness_slider = wibox.widget {
    bar_shape = gears.shape.rounded_rect,
    bar_height = dpi(3),
    bar_color = beautiful.white,
    handle_color = beautiful.white,
    handle_shape = gears.shape.circle,
    handle_width = dpi(15),
    handle_border_width = dpi(1),
    handle_border_color = beautiful.border_color,
    value = 50,
    maximum = 100,
    forced_height = dpi(20),
    forced_width = dpi(140),
    widget = wibox.widget.slider
}

local brightness_icon_popup = wibox.widget {
    markup = '<span font="Ubuntu Nerd Font 110" foreground="' .. beautiful.white .. '">' .. "󰖨" .. '</span>',
    align = "center",
    widget = wibox.widget.textbox
}

local brightness_icon = wibox.widget {
    markup = '<span font="' .. beautiful.font_icon .. '"foreground="' .. beautiful.red .. '">󰖨 </span>',
    widget = wibox.widget.textbox,
}

local brightness_widget = wibox.widget {
    {
        layout = wibox.layout.fixed.horizontal,
        brightness_icon,
        wibox.widget {
            brightness,
            fg = beautiful.red,
            widget = wibox.container.background
        },
    },
    spacing = dpi(1),
    layout = wibox.layout.fixed.horizontal,
}

local brightness_popup = awful.popup {
    screen = screen.primary,
    widget = {
        {
            widget = wibox.container.margin,
            margins = dpi(20),
        },
        widget = wibox.container.place,
    },
    ontop = true,
    visible = false,
    focus = false,
    placement = awful.placement.centered,
    shape = gears.shape.rounded_rect,
    bg = beautiful.bg_popup or beautiful.bg_normal,
}

local popup_timer = gears.timer {
    timeout = 2,
    single_shot = true,
    callback = function()
        brightness_popup.visible = false
    end
}

local brightness_slider_with_margins = wibox.container.margin(brightness_slider, dpi(40), dpi(40), dpi(0), dpi(20))

brightness_popup:setup {
    {
        {
            brightness_icon_popup,
            {
                brightness_slider_with_margins,
                widget = wibox.container.margin,
            },
            layout = wibox.layout.fixed.vertical
        },
        layout = wibox.container.place
    },
    widget = wibox.container.background,
}

local function update_brightness_widget()
    awful.spawn.easy_async("xbacklight -get", function(stdout)
        local brightness_level = math.floor(stdout + 0.5)
        brightness_slider.value = tonumber(brightness_level)
    end)
end

local function show_brightness_popup()
    brightness_popup.visible = true
    popup_timer:start()
end

awesome.connect_signal("brightness::increase", function()
    awful.spawn("xbacklight -inc 10")
    update_brightness_widget()
    show_brightness_popup()
end)

awesome.connect_signal("brightness::decrease", function()
    awful.spawn("xbacklight -dec 10")
    update_brightness_widget()
    show_brightness_popup()
end)

awesome.connect_signal("signal::brightness", function(brightness_level)
    brightness.text = tostring(brightness_level) .. '%'
end)

return brightness_widget

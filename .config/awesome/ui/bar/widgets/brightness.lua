
-- Required libraries
local awful = require("awful")
local wibox = require('wibox')
local gears = require("gears")
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi
local watch = require('awful.widget.watch')

local brightness = wibox.widget.textbox()
brightness.font = beautiful.font

local brightness_slider = wibox.widget {
    {
        id = 'brightness_slider',
        widget = wibox.widget.slider,
        bar_shape = gears.shape.rounded_rect,
        bar_height = dpi(2),
        bar_color = beautiful.red,
        handle_color = beautiful.red,
        handle_shape = gears.shape.circle,
        handle_width = dpi(10),
        handle_border_color = beautiful.red,
        handle_border_width = dpi(1),
        maximum = 100,
        minimum = 0,
        value = 50,
        forced_height = dpi(10),
        forced_width = dpi(100),
        widget = wibox.widget.slider,
    },
    margins = dpi(5),
    visible = false,
    widget = wibox.container.margin,
}

-- Function to update the brightness level based on the slider value
local function update_brightness(slider_value)
    awful.spawn('xbacklight -set ' .. slider_value)
    brightness.text = slider_value .. '%'
end

-- Connect signals to update the brightness level with the slider and keyboard
brightness_slider.brightness_slider:connect_signal("property::value", function()
    local slider_value = brightness_slider.brightness_slider:get_value()
    update_brightness(slider_value)
end)

local brightness_icon = wibox.widget {
    markup = '<span font="' .. beautiful.font_icon .. '"foreground="'.. beautiful.red ..'">󰃠 </span>',
    widget = wibox.widget.textbox,
}

local brightness_widget = wibox.widget {
    {
        layout = wibox.layout.fixed.horizontal,
        brightness_icon,
        brightness_slider,
        wibox.widget{
            brightness,
            fg = beautiful.red,
            widget = wibox.container.background
        },
    },
    spacing = dpi(1),
    layout = wibox.layout.fixed.horizontal,
}

brightness_widget:connect_signal("mouse::enter", function()
    brightness_slider.visible = true
end)

brightness_widget:connect_signal("mouse::leave", function()
    brightness_slider.visible = false
end)

watch([[bash -c "xbacklight -get"]], 2, function(_, stdout)
    local brightness_level = math.floor(stdout+0.5)  -- Round up to nearest integer
    brightness.text = brightness_level .. '%'
    
    -- Update slider value based on the brightness level
    brightness_slider.brightness_slider:set_value(brightness_level)

    collectgarbage('collect')
end)

return brightness_widget
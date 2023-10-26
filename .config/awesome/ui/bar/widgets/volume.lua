
-- Required libraries
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = require("beautiful").xresources.apply_dpi
local watch = require("awful.widget.watch")

local volume = wibox.widget.textbox()
volume.font = beautiful.font

local volume_slider = wibox.widget {
    {
        id = "volume_slider",
        widget = wibox.widget.slider,
        bar_shape = gears.shape.rounded_rect,
        bar_height = dpi(2),
        bar_color = beautiful.pink,
        handle_color = beautiful.pink,
        handle_shape = gears.shape.circle,
        handle_width = dpi(10),
        handle_border_color = beautiful.pink,
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

-- Function to update the volume level based on the slider value
local function update_volume(slider_value)
    awful.spawn('pactl set-sink-volume 0 ' .. slider_value .. '%')
    volume.text = slider_value .. '%'
end

-- Connect signals to update the volume level with the slider and keyboard
volume_slider.volume_slider:connect_signal("property::value", function()
    local slider_value = volume_slider.volume_slider:get_value()
    update_volume(slider_value)
end)

local volume_icon = wibox.widget {
    markup = '<span font="' .. beautiful.font_icon .. '"foreground="'.. beautiful.pink ..'">墳 </span>',
    widget = wibox.widget.textbox,
}

local volume_widget = wibox.widget {
    {
        layout = wibox.layout.fixed.horizontal,
        volume_icon,
        volume_slider,
        wibox.widget{
            volume,
            fg = beautiful.pink,
            widget = wibox.container.background
        },
    },
    spacing = dpi(1),
    layout = wibox.layout.fixed.horizontal,
}

volume_widget:connect_signal("mouse::enter", function()
    volume_slider.visible = true
end)

volume_widget:connect_signal("mouse::leave", function()
    volume_slider.visible = false
end)

-- Toggle the volume when widget is clicked
volume:connect_signal("button::press", function(_, _, _, button)
    if (button == 1) then
        awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
    end
end)


local function update_volume_widget()
    awful.spawn.easy_async([[bash -c "amixer get Master | grep -E '(Left|Mono):' | awk -F'[][]' '{print $2, $4}'"]], function(stdout)
        local volume_level, is_muted = string.match(stdout, "(%d+)%% (%a+)")
 
        if volume_level and is_muted then
            -- Update the volume text
            volume.text = volume_level .. '%'
 
            -- Update the volume slider
            volume_slider.volume_slider:set_value(tonumber(volume_level))
 
            -- Update the volume icon
            if is_muted == "off" then
                volume_icon.markup = '<span font="' .. beautiful.font_icon .. '" foreground="' .. beautiful.pink .. '">婢 </span>'
            else
                volume_icon.markup = '<span font="' .. beautiful.font_icon .. '" foreground="' .. beautiful.pink .. '">墳 </span>'
            end
        end
    end)
end

watch([[bash -c "amixer get Master | grep -E '(Left|Mono):' | awk -F'[][]' '{print $2, $4}'"]], 1, function(_, stdout)
    update_volume_widget()
    collectgarbage("collect")
end)

return volume_widget

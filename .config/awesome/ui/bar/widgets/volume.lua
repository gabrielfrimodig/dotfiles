-- Required libraries
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local watch = require("awful.widget.watch")

local volume = wibox.widget.textbox()
volume.font = beautiful.font

local volume_icon = wibox.widget.textbox()

local function set_icon(is_muted)
    local icon = is_muted == "true" and "婢 " or "墳 "
    volume_icon.markup = string.format('<span font="%s" foreground="%s">%s</span>',
                                       beautiful.font_icon, beautiful.pink, icon)
end

set_icon("false")

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
    },
    margins = dpi(5),
    visible = false,
    widget = wibox.container.margin,
}

local function update_volume(slider_value)
    awful.spawn('pamixer --set-volume ' .. slider_value)
    volume.text = slider_value .. '%'
end

volume_slider.volume_slider:connect_signal("property::value", function()
    update_volume(volume_slider.volume_slider:get_value())
end)

local volume_widget = wibox.widget {
    {
        layout = wibox.layout.fixed.horizontal,
        volume_icon,
        volume_slider,
        {
            volume,
            fg = beautiful.pink,
            widget = wibox.container.background
        },
    },
    spacing = dpi(1),
    layout = wibox.layout.fixed.horizontal,
}

volume_widget:connect_signal("mouse::enter", function() volume_slider.visible = true end)
volume_widget:connect_signal("mouse::leave", function() volume_slider.visible = false end)

volume:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then awful.spawn("pamixer --toggle-mute") end
end)

local function update_volume_widget()
    awful.spawn.easy_async("pamixer --get-volume --get-mute", function(stdout)
        local is_muted, volume_level = stdout:match("(%a+)%s(%d+)")
        if volume_level then
            volume.text = volume_level .. '%'
            volume_slider.volume_slider:set_value(tonumber(volume_level))
        end
        set_icon(is_muted)
    end)
end

watch("pamixer --get-volume --get-mute", 1, function()
    update_volume_widget()
    collectgarbage("collect")
end)

return volume_widget

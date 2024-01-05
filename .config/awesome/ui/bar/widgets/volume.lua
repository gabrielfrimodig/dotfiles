-- Required libraries
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local volume = wibox.widget.textbox()
volume.font = beautiful.widget_text
local volume_icon = wibox.widget.textbox()
volume_icon.font = beautiful.widget_icon
local volume_icon_popup = wibox.widget.textbox()
volume_icon_popup.font = beautiful.popup_icon

local volume_widget = wibox.widget {
    {
        volume_icon,
        fg = beautiful.fg_volume,
        widget = wibox.container.background
    },
    {
        volume,
        fg = beautiful.fg_volume,
        widget = wibox.container.background
    },
    spacing = dpi(4),
    layout = wibox.layout.fixed.horizontal
}

local volume_slider = wibox.widget {
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

local volume_popup = awful.popup {
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
    bg = beautiful.bg_popup or beautiful.black,
}

local popup_timer = gears.timer {
    timeout = 2,
    single_shot = true,
    callback = function()
        volume_popup.visible = false
    end
}

local volume_slider_with_margins = wibox.container.margin(volume_slider, dpi(40), dpi(40), dpi(0), dpi(20))

--- get_current_audio_output_device: Determines the current audio output device used by the system.
-- This function executes a shell command using 'pactl' to list audio sinks and parses the output to find the active port.
-- @return A string indicating the current audio output device. Either 'headphones', 'speakers', or 'unknown'.
local function get_current_audio_output_device()
    local handle = io.popen("pactl list sinks")
    local result = handle:read("*a")
    handle:close()

    for line in result:gmatch("[^\r\n]+") do
        if line:find("Active Port:") then
            local port = line:match("Active Port: (.+)")
            if port and port:find("headphones") then
                return "headphones"
            else
                return "speakers"
            end
        end
    end

    return "unknown"
end

--- set_icon: Updates the volume icon based on the mute status and the current audio output device.
-- Different icons are used to represent the combinations of mute status and device type.
-- @param is_muted A string indicating the mute status. Possible values are "true" (muted) or "false" (unmuted).
-- The function updates theme variables 'volume_icon' and 'volume_icon_popup' with the appropriate icon.
local function set_icon(is_muted)
    local device = get_current_audio_output_device()
    local icon

    if is_muted == "true" and device == "headphones" then
        icon = "󰟎"
    elseif is_muted == "true" then
        icon = "󰖁"
    elseif device == "headphones" then
        icon = "󰋋"
    else
        icon = "󰕾"
    end

    volume_icon.text = icon
    volume_icon_popup.text = icon
end

volume_popup:setup {
    {
        {
            {
                volume_icon_popup,
                fg = beautiful.white,
                widget = wibox.container.background
            },
            {
                volume_slider_with_margins,
                widget = wibox.container.margin,
            },
            layout = wibox.layout.fixed.vertical
        },
        layout = wibox.container.place
    },
    widget = wibox.container.background,
}

volume_icon_popup.align = "center"
volume_icon_popup.valign = "center"

volume:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle") end
end)

--- update_volume_widget: Updates the volume widget with the current volume level and mute status.
-- This function executes shell commands to get the current volume level and mute status of the default sink using 'pactl'.
-- It parses the output to extract the volume level and mute status.
-- The volume level is updated as well as the volume bar (popup). The color of the volume slider (popup) is updated based on the volume level.
local function update_volume_widget()
    awful.spawn.easy_async_with_shell("pactl get-sink-volume @DEFAULT_SINK@; pactl get-sink-mute @DEFAULT_SINK@",
        function(stdout)
            local volume_level = stdout:match("Volume: front.- (%d+)%%") or "0"
            local is_muted = tostring(stdout:match("Mute: (%a+)") == "yes")

            if volume_level then
                volume.text = volume_level .. '%'
                volume_slider.value = tonumber(volume_level)
                if tonumber(volume_level) >= 90 then
                    volume_slider.bar_color = beautiful.red
                    volume_slider.handle_color = beautiful.red
                elseif tonumber(volume_level) >= 70 then
                    volume_slider.bar_color = beautiful.orange
                    volume_slider.handle_color = beautiful.orange
                else
                    volume_slider.bar_color = beautiful.white
                    volume_slider.handle_color = beautiful.white
                end
            end
            set_icon(is_muted)
        end)
end

--- show_volume_popup: Displays the volume popup and starts a timer for auto-hiding.
-- This function makes the volume popup visible on the screen.
-- It also starts a timer ('popup_timer') which will automatically hide the popup after a set duration.
-- This function provides visual feedback to the user.
local function show_volume_popup()
    volume_popup.visible = true
    popup_timer:start()
end

awesome.connect_signal("volume::increase", function()
    awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%", false)
    update_volume_widget()
    show_volume_popup()
end)

awesome.connect_signal("volume::decrease", function()
    awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%", false)
    update_volume_widget()
    show_volume_popup()
end)

awesome.connect_signal("volume::mute", function()
    awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle", false)
    update_volume_widget()
    show_volume_popup()
end)

watch("pactl get-sink-volume @DEFAULT_SINK@; pactl get-sink-mute @DEFAULT_SINK@", 1, function()
    update_volume_widget()
    collectgarbage("collect")
end)

return volume_widget

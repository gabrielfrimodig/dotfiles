-- Required libraries
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local mic_icon = wibox.widget.textbox()
mic_icon.font = beautiful.popup_icon
mic_icon.text = "󰍬"

local mic_popup = awful.popup {
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
        mic_popup.visible = false
    end
}

-- Add the box content
mic_popup:setup {
    {
        {
            mic_icon,
            fg = beautiful.white,
            layout = wibox.layout.fixed.vertical
        },
        layout = wibox.container.place
    },
    widget = wibox.container.background,
}

-- This function displays the microphone status popup.
-- It makes the 'mic_popup' widget visible, providing a visual indication of the microphone's current state.
-- Additionally, it starts a timer ('popup_timer') to automatically hide the popup after a predefined duration.
local function show_mic_popup()
    mic_popup.visible = true
    popup_timer:start()
end

-- This function updates the microphone icon based on its mute status.
local function set_icon(is_muted)
    mic_icon.text = is_muted and "󰍭" or "󰍬"
end

-- This signal handler toggles the microphone's mute state and updates the UI accordingly.
-- It uses pamixer to toggle the mute state of the default audio source.
-- After toggling, it queries the current mute state and updates the microphone icon based on whether it's muted.
-- Finally, it displays a popup to provide visual feedback on the microphone's mute status.
awesome.connect_signal("mic::toggle", function()
    awful.spawn.easy_async("pactl set-source-mute @DEFAULT_SOURCE@ toggle", function()
        awful.spawn.easy_async_with_shell("pactl get-source-mute @DEFAULT_SOURCE@", function(stdout)
            local is_muted = stdout:match("Mute:%s*yes") ~= nil
            set_icon(is_muted)
            show_mic_popup()
        end)
    end)
end)

return mic_popup

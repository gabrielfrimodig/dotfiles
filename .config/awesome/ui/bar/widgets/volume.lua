
-- Required libraries
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful").xresources.apply_dpi
local watch = require("awful.widget.watch")

local volume = wibox.widget.textbox()
volume.font = "JetBrains Mono 10"

-- Create a variable to hold the volume icon
local volume_icon = wibox.widget.textbox()

-- Define the font and color for the volume icon
volume_icon.font = "JetBrains Mono 18"
volume_icon.color = "#f5c2e7"

-- Set the initial icon to the volume up icon
volume_icon.markup = '<span font="' .. "JetBrains Mono 18" .. '"foreground="'.. "#f5c2e7" ..'">墳 </span>'

watch([[bash -c "amixer get Master | grep 'Left:' | awk -F'[][]' '{ print $2 }'"]], 1, function(_, stdout)
    volume.text = stdout
    collectgarbage("collect")
end)

-- Watch for changes to the mute status
watch([[bash -c "amixer get Master | grep 'Left:' | awk -F'[][]' '{ print $4 }'"]], 1, function(_, stdout)
    -- If the volume is muted, set the icon to the volume off icon
    if string.match(stdout, "off") then
        volume_icon.markup = '<span font="' .. "JetBrains Mono 18" .. '"foreground="'.. "#f5c2e7" ..'">婢 </span>'
    -- Otherwise, set the icon to the volume up icon
    else
        volume_icon.markup = '<span font="' .. "JetBrains Mono 18" .. '"foreground="'.. "#f5c2e7" ..'">墳 </span>'
    end
end)

return wibox.widget {
    volume_icon,
    wibox.widget{
        volume, 
        fg = "#f5c2e7",
        widget = wibox.container.background
    },
    spacing = dpi(2),
    layout = wibox.layout.fixed.horizontal
}



-- Required libraries
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi
local watch = require('awful.widget.watch')

local brightness = wibox.widget.textbox()
brightness.font = "Jetbrains Mono 10"
local font = "Jetbrains Mono 18"

watch([[bash -c "xbacklight -get"]], 2, function(_, stdout)
    local brightness_level = math.floor(stdout+0.5)  -- Round up to nearest integer
    brightness.text = brightness_level .. '%'

    collectgarbage('collect')
end)

brightness_icon = wibox.widget {
    markup = '<span font="' .. font .. '"foreground="'.. "#f38ba8" ..'">☀ </span>',
    widget = wibox.widget.textbox,
}

return wibox.widget {
    brightness_icon,
    wibox.widget{
        brightness, 
        fg = "#f38ba8",
        widget = wibox.container.background
    },
    spacing = dpi(1),
    layout = wibox.layout.fixed.horizontal
}


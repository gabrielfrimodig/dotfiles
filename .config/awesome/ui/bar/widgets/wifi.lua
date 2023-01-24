
-- Required libraries
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi
local watch = require('awful.widget.watch')

local wifi = wibox.widget.textbox()
wifi.font = "Jetbrains Mono 10"
local font = "Jetbrains Mono 18"

wifi_icon = wibox.widget {
    widget = wibox.widget.textbox,
}
watch([[bash -c "nmcli -t -f active,ssid,signal dev wifi | grep '^yes' | cut -d':' -f2,3"]], 2, function(_, stdout)
    local ssid, signal = stdout:match("(.*):(%d+)")
    local strength = tonumber(signal)
    local wifi_symbol = ''

    if strength >= 80 then
        wifi_symbol = ' '
    elseif strength >= 60 then
        wifi_symbol = ' '
    elseif strength >= 40 then
        wifi_symbol = ' '
    elseif strength >= 20 then
        wifi_symbol = ' '
    else
        wifi_symbol = ' '
    end

    wifi.text = ssid
    wifi_icon.markup = '<span font="' .. font .. '"foreground="'.. "#fab387" ..'">' .. wifi_symbol .. '</span>'
    collectgarbage('collect')
end)

return wibox.widget {
    wifi_icon,
    wibox.widget{
        wifi, 
        fg = "#fab387",
        widget = wibox.container.background
    },
    spacing = dpi(2),
    layout = wibox.layout.fixed.horizontal
}


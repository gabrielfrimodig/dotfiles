-- Required libraries
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi
local watch = require('awful.widget.watch')

local wifi_icon = wibox.widget.textbox()

local wifi_name = wibox.widget.textbox()
wifi_name.font = beautiful.font

local function update_widget(ssid, signal_strength)
    local wifi_symbol = ''
    
    if signal_strength >= 80 then
        wifi_symbol = ' '
    elseif signal_strength >= 60 then
        wifi_symbol = ' '
    elseif signal_strength >= 45 then
        wifi_symbol = ' '
    elseif signal_strength >= 40 then
        wifi_symbol = ' '
    elseif signal_strength >= 20 then
        wifi_symbol = ' '
    else
        wifi_symbol = ' '
    end

    wifi_icon.markup = '<span font="' .. beautiful.font_icon .. '" foreground="'.. beautiful.peach ..'">' .. wifi_symbol ..'</span>'
    wifi_name.markup = '<span font="' .. beautiful.font .. '" foreground="'.. beautiful.peach ..'">' .. ssid .. '</span>'
end

watch([[bash -c "nmcli -t -f active,ssid,signal dev wifi | grep '^yes' | cut -d':' -f2,3"]], 2, function(_, stdout)
    local ssid, signal_strength = stdout:match("(.*):(%d+)")
    signal_strength = tonumber(signal_strength)
    update_widget(ssid, signal_strength)
    collectgarbage('collect')
end)

local wifi_widget = wibox.widget {
    wifi_icon,
    wibox.widget{
        wifi_name,
        widget = wibox.container.margin,
        left = dpi(2)
    },
    layout = wibox.layout.fixed.horizontal,
}

return wifi_widget

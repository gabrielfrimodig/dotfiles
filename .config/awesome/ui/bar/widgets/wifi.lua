-- Required libraries
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local wifi_name = wibox.widget.textbox()
wifi_name.font = beautiful.widget_text
local wifi_icon = wibox.widget.textbox()
wifi_icon.font = beautiful.widget_icon

local wifi_widget = wibox.widget {
    {
        wifi_icon,
        fg = beautiful.fg_wifi,
        widget = wibox.container.background
    },
    {
        wifi_name,
        fg = beautiful.fg_wifi,
        widget = wibox.container.background
    },
    spacing = dpi(4),
    layout = wibox.layout.fixed.horizontal,
}

local wifi_tooltip = awful.tooltip({
    objects = { wifi_widget },
    mode = "outside",
    align = "right",
    delay_show = 1,
    border_width = dpi(1),
    bg = beautiful.bg_tooltip,
    fg = beautiful.fg_wifi,
    border_color = beautiful.black,
    shape = gears.shape.rounded_rect,
    font = beautiful.widget_text,
    margins = dpi(8),
})

--- update_widget: Updates the WiFi widget with the current network SSID and signal strength.
-- This function selects an icon to represent the WiFi signal strength based on predefined thresholds.
-- It updates the wifi_icon with the chosen symbol and the wifi_name with the SSID of the current network.
-- Additionally, if the wifi_tooltip is available, it sets its text to display the SSID and signal strength.
-- @param ssid The SSID of the current WiFi network.
-- @param signal_strength The signal strength of the current WiFi network, represented as a percentage.
local function update_widget(ssid, signal_strength)
    local wifi_symbol = ''

    if signal_strength >= 80 then
        wifi_symbol = "󰤨"
    elseif signal_strength >= 60 then
        wifi_symbol = "󰤥"
    elseif signal_strength >= 45 then
        wifi_symbol = "󰤢"
    elseif signal_strength >= 40 then
        wifi_symbol = "󰤟"
    elseif signal_strength >= 20 then
        wifi_symbol = "󰤯"
    else
        wifi_symbol = "󰤮"
    end

    wifi_icon.text = wifi_symbol
    wifi_name.text = ssid

    if wifi_tooltip then
        wifi_tooltip:set_text("ESSID: " .. ssid .. "\nSignal Strength: " .. signal_strength .. "%")
    end
end

watch([[bash -c "nmcli -t -f active,ssid,signal dev wifi | grep '^yes' | cut -d':' -f2,3"]], 2, function(_, stdout)
    local ssid, signal_strength = stdout:match("(.*):(%d+)")
    signal_strength = tonumber(signal_strength)
    update_widget(ssid, signal_strength)

    collectgarbage("collect")
end)

return wifi_widget

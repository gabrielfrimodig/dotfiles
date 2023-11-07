
-- Required libraries
local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")
local tooltip = require("awful.tooltip")
local dpi = require("beautiful").xresources.apply_dpi

local percentage = wibox.widget.textbox()
percentage.font = beautiful.font
local battery_icon = wibox.widget.textbox()
battery_icon.font = beautiful.font_icon

local icons = {
    [0] = '', -- <= 10%
    [10] = '', -- <= 20%
    [20] = '', -- <= 30%
    [30] = '', -- <= 40%
    [40] = '', -- <= 50%
    [50] = '', -- <= 60%
    [60] = '', -- <= 70%
    [70] = '', -- <= 80%
    [80] = '', -- <= 90%
    [90] = '', -- <= 100%
    [100] = '',
}

local battery_widget = wibox.widget {
    {
        battery_icon,
        fg = beautiful.mauve,
        widget = wibox.container.background
    },
    {
        percentage, 
        fg = beautiful.mauve,
        widget = wibox.container.background
    },
    spacing = dpi(4),
    layout = wibox.layout.fixed.horizontal
}

local battery_tooltip = tooltip({
    objects = { battery_widget },
    mode = 'outside',
    align = 'right',
    delay_show = 1
})

local function update_widget(widget, stdout)
    local battery_info = {}
    local capacities = {}
    local tooltip_message = "Time remaining: Not available"
    
    for s in stdout:gmatch('[^\r\n]+') do
        local status, charge_str, time = string.match(s, '.+: (%a+), (%d?%d?%d)%%, (%d+:%d+)')
        if status ~= nil then
            table.insert(battery_info, {
                status = status,
                charge = tonumber(charge_str),
                time = time
            })
        else
            local cap_str = string.match(s, '.+:.+last full capacity (%d+)')
            table.insert(capacities, tonumber(cap_str))
        end
    end

    local capacity = 0
    for _, cap in ipairs(capacities) do
        capacity = capacity + cap
    end

    local charge = 0
    local status
    local time
    for i, batt in ipairs(battery_info) do
        if batt.charge >= charge then
            status = batt.status
            time = batt.time
        end

        charge = charge + batt.charge * capacities[i]
    end
    charge = charge / capacity

    percentage.text = math.floor(charge) .. "%"

    if status == "Charging" then
        battery_icon.text = ' '
        if time then
            tooltip_message = "Charging: " .. time .. " until full"
        end
    elseif status == "Full" then
        battery_icon.text = ''
        tooltip_message = "Battery is full"
    else
        battery_icon.text = icons[math.floor(charge / 10) * 10]
        if time then
            tooltip_message = "Time remaining: " .. time
        end
    end

    -- Set the tooltip text
    battery_tooltip.text = tooltip_message

    collectgarbage("collect")
end

watch('acpi -i', 10, function(widget, stdout)
    update_widget(widget, stdout)
end, battery_widget)


return battery_widget

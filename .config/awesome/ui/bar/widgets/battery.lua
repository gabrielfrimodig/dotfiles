
-- Required libraries
local awful = require("awful")
local wibox = require("wibox")
local watch = require('awful.widget.watch')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi

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

local function update_widget(widget, stdout)
    local battery_info = {}
    local capacities = {}
    for s in stdout:gmatch('[^\r\n]+') do
        local status, charge_str, time = string.match(s, '.+: (%a+), (%d?%d?%d)%%,?.*')
        if status ~= nil then
            table.insert(battery_info, {
                status = status,
                charge = tonumber(charge_str)
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
    for i, batt in ipairs(battery_info) do
        if batt.charge >= charge then
            status = batt.status
        end

        charge = charge + batt.charge * capacities[i]
    end
    charge = charge / capacity

    percentage.text = math.floor(charge) .. "%"

    if status == 'Charging' then
        battery_icon.text = ' '
    elseif status == 'Full' then
        battery_icon.text = ''
    else
        battery_icon.text = icons[math.floor(charge / 10) * 10]
    end

    collectgarbage('collect')
end

watch('acpi -i', 10, function(widget, stdout)
    update_widget(widget, stdout)
end, battery_widget)


return battery_widget

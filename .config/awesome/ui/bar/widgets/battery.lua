-- Required libraries
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local percentage = wibox.widget.textbox()
percentage.font = beautiful.widget_text
local battery_icon = wibox.widget.textbox()
battery_icon.font = beautiful.widget_icon_battery

local icons = {
    [0]   = '', -- <= 10%
    [10]  = '', -- <= 20%
    [20]  = '', -- <= 30%
    [30]  = '', -- <= 40%
    [40]  = '', -- <= 50%
    [50]  = '', -- <= 60%
    [60]  = '', -- <= 70%
    [70]  = '', -- <= 80%
    [80]  = '', -- <= 90%
    [90]  = '', -- <= 100%
    [100] = '',
}

local battery_widget = wibox.widget {
    {
        battery_icon,
        fg = beautiful.fg_battery,
        widget = wibox.container.background
    },
    {
        percentage,
        fg = beautiful.fg_battery,
        widget = wibox.container.background
    },
    spacing = dpi(4),
    layout = wibox.layout.fixed.horizontal
}

local battery_tooltip = require("awful.tooltip")({
    objects = { battery_widget },
    mode = "outside",
    align = "right",
    delay_show = 1,
    border_width = dpi(1),
    bg = beautiful.bg_tooltip,
    fg = beautiful.fg_battery,
    border_color = beautiful.black,
    shape = gears.shape.rounded_rect,
    font = beautiful.widget_text,
    margins = dpi(8),
})

--- update_widget: Updates the battery widget with the current battery status and charge level.
-- This function parses the output from the 'acpi -i' command to extract battery status, charge level, and time remaining.
-- It iterates through each line of the command output, categorizing data into battery info and capacities.
-- The function updates the battery icon and tooltip text based on the battery's current status (charging, full, or discharging).
-- If available, the tooltip also includes the time remaining for charging or discharging.
-- The battery charge percentage is displayed in the battery_value widget.
-- @param stdout The string output from the 'acpi -i' command containing battery information.
local function update_widget(stdout)
    local battery_info = {}
    local capacities = {}
    local time_remaining = nil

    for s in stdout:gmatch('[^\r\n]+') do
        local status, charge_str, time = string.match(s, '.+: (%a+), (%d?%d?%d)%%,?%s*(.-)$')
        if status ~= nil then
            table.insert(battery_info, {
                status = status,
                charge = tonumber(charge_str),
                time = time
            })
            if time and not time:match("remaining time: unknown") then
                time_remaining = time
            end
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

    local tooltip_text = ""
    if status == "Charging" then
        battery_icon.text = ' '
        tooltip_text = "Charging: " .. math.floor(charge) .. "%"
        if time_remaining then
            tooltip_text = tooltip_text .. "\n" .. time_remaining
        end
    elseif status == "Full" then
        battery_icon.text = ''
        tooltip_text = "Battery is full"
    else
        battery_icon.text = icons[math.floor(charge / 10) * 10]
        tooltip_text = "Battery: " .. math.floor(charge) .. "%"
        if time_remaining then
            tooltip_text = tooltip_text .. "\n" .. time_remaining
        else
            tooltip_text = tooltip_text .. "\nTime: Not available"
        end
    end

    battery_tooltip:set_text(tooltip_text)

    collectgarbage("collect")
end

watch('acpi -i', 10, function(widget, stdout)
    update_widget(stdout)
end, battery_widget)

return battery_widget

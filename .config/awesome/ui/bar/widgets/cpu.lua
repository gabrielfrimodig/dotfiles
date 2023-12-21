-- Required libraries
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local cpu = wibox.widget.textbox()
cpu.font = beautiful.widget_text
local cpu_icon = wibox.widget.textbox()
cpu_icon.font = beautiful.widget_icon
cpu_icon.text = ''

local total_prev = 0
local idle_prev = 0

local cpu_widget = wibox.widget {
    {
        cpu_icon,
        fg = beautiful.fg_cpu,
        widget = wibox.container.background
    },
    {
        cpu,
        fg = beautiful.fg_cpu,
        widget = wibox.container.background
    },
    spacing = dpi(4),
    layout = wibox.layout.fixed.horizontal
}

watch([[bash -c "cat /proc/stat | grep '^cpu '"]], 2, function(_, stdout, _, _, exit_code)
    if exit_code ~= 0 then
        cpu.text = "Error"
        return
    end

    local user, nice, system, idle = stdout:match("(%d+)%s+(%d+)%s+(%d+)%s+(%d+)")
    if not (user and nice and system and idle) then
        cpu.text = "N/A"
        return
    end

    local total = user + nice + system + idle
    local diff_idle = idle - idle_prev
    local diff_total = total - total_prev
    local diff_usage = 0
    if diff_total ~= 0 then
        diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10
    end

    cpu.text = math.floor(diff_usage) .. "%"
    -- Makes sure the icon doens't shift when single digit
    if diff_usage < 10 then cpu.text = " " .. cpu.text end

    total_prev = total
    idle_prev = idle

    collectgarbage("collect")
end)

return cpu_widget

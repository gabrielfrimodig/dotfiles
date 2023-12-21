-- Required libraries
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local memory = wibox.widget.textbox()
memory.font = beautiful.widget_text
local memory_icon = wibox.widget.textbox()
memory_icon.font = beautiful.widget_icon
memory_icon.text = ''

local memory_widget = wibox.widget {
    {
        memory_icon,
        fg = beautiful.fg_ram,
        widget = wibox.container.background
    },
    {
        memory,
        fg = beautiful.fg_ram,
        widget = wibox.container.background
    },
    spacing = dpi(4),
    layout = wibox.layout.fixed.horizontal
}

watch([[bash -c "free -h | awk '/^Mem/ { print $3 }' | sed s/i//g"]], 2, function(_, stdout, _, _, exit_code)
    if exit_code ~= 0 or not stdout:match("%S") then
        memory.text = "Error"
        return
    end

    memory.text = stdout
end)

return memory_widget

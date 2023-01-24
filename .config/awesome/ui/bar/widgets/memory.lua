
-- Required libraries 
local wibox = require('wibox')
local beautiful = require('beautiful')
local watch = require('awful.widget.watch')
local dpi = require('beautiful').xresources.apply_dpi

local memory = wibox.widget.textbox()
memory.font = "Jetbrains Mono 10"

watch([[bash -c "free -h | awk '/^Mem/ { print $3 }' | sed s/i//g"]], 2, function(_, stdout)
    memory.text = stdout
end)

memory_icon = wibox.widget {
	markup = '<span font="' .. beautiful.font_icon .. '"foreground="'.. beautiful.pink ..'"> </span>',
	widget = wibox.widget.textbox,
}

return wibox.widget {
	memory_icon,
    wibox.widget{
        memory, 
        fg = beautiful.pink,
        widget = wibox.container.background
    },
    spacing = dpi(2),
    layout = wibox.layout.fixed.horizontal
}


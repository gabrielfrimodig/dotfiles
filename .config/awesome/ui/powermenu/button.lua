local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local function create_button(icon, text, command, color)
    local icon_widget = wibox.widget {
        markup = '<span font="Ubuntu Nerd Font Bold 20" foreground="' .. beautiful.black .. '">' .. icon .. '</span>',
        widget = wibox.widget.textbox,
        align = "center"
    }

    local text_widget = wibox.widget {
        markup = '<span font="Ubuntu Nerd Font 10" foreground="' .. beautiful.black .. '">' .. text .. '</span>',
        widget = wibox.widget.textbox,
        align = "center"
    }

    local button_container = wibox.widget {
        icon_widget,
        text_widget,
        spacing = dpi(5),
        layout = wibox.layout.fixed.horizontal
    }

    local button = wibox.container.background(
        wibox.container.margin(button_container, dpi(10), dpi(10), dpi(10), dpi(10)),
        color,
        gears.shape.rounded_rect
    )

    button:connect_signal("mouse::enter", function()
        button.bg = beautiful.bg_focus
    end)

    button:connect_signal("mouse::leave", function()
        button.bg = color
    end)

    button:connect_signal("button::press", function()
        awful.spawn(command)
    end)

    return button
end

return create_button

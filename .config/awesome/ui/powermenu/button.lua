-- Required libraries
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--- Creates a customizable button widget with an icon and text for the Powermenu.
-- The button changes its background color on mouse hover and executes the command on click.
-- @param icon The icon to be displayed on the button, formatted as a string.
-- @param text The text label for the button.
-- @param command The shell command to execute when the button is pressed.
-- @param color The background color of the button.
-- @return A fully constructed button widget with specified properties and behavior.
local function create_button(icon, text, command, color)
    local icon_widget = wibox.widget {
        markup = string.format('<span font="%s" foreground="%s">%s</span>', beautiful.powermenu_icon, beautiful.black, icon),
        widget = wibox.widget.textbox,
        align = "center"
    }

    local text_widget = wibox.widget {
        markup = string.format('<span font="%s" foreground="%s">%s</span>', beautiful.powermenu_button, beautiful.black, text),
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
        button.bg = beautiful.button_focus
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

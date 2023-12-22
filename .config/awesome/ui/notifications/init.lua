-- Required libraries
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = dpi(30)
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.timeout = 5
naughty.config.defaults.title = "Notification"
naughty.config.defaults.position = "top_right"

-- This function customizes the appearance and behavior of notifications.
-- When a notification request is received, it sets a default timeout of 10 seconds.
-- It checks for an icon associated with the notification, falling back to a default icon if none is provided.
-- The notification layout is defined with a left part for the app icon and a right part for the content.
-- The content includes a custom title and message widget, styled according to the theme.
naughty.connect_signal("request::display", function(notify)
    notify.timeout = 10

    local appicon = notify.icon or notify.app_icon
    if not appicon then appicon = beautiful.notification_icon end

    local appicon_widget = wibox.widget {
        {
            id = "icon",
            image = appicon,
            resize = true,
            widget = wibox.widget.imagebox,
        },
        shape = gears.shape.rounded_rect,
        forced_width = dpi(40),
        forced_height = dpi(40),
        widget = wibox.container.background
    }

    naughty.layout.box {
        notification = notify,
        type = "notification",
        bg = beautiful.bg_popup,
        fg = beautiful.white,
        widget_template = {
            {
                {
                    {
                        {
                            -- Left part
                            {
                                appicon_widget,
                                layout = wibox.container.place
                            },
                            bg = beautiful.black,
                            forced_width = dpi(60),
                            widget = wibox.container.background,
                        },
                        {
                            -- Right part (Notification content)
                            {
                                {
                                    -- Custom Title Widget
                                    widget = wibox.widget.textbox,
                                    text = notify.title,
                                    font = beautiful.notification_bold,
                                    fg = beautiful.white,
                                },
                                {
                                    -- Custom Message Widget
                                    widget = wibox.widget.textbox,
                                    text = notify.message,
                                    font = beautiful.notification_text,
                                    fg = beautiful.white,
                                },
                                layout = wibox.layout.align.vertical,
                            },
                            widget = wibox.container.margin,
                            margins = dpi(10),
                        },
                        layout = wibox.layout.fixed.horizontal,
                    },
                    widget = wibox.container.background,
                    bg = beautiful.black,
                    opacity = 0.6,
                },
                widget = wibox.container.margin,
                margins = 0,
            },
            strategy = "max",
            forced_width = dpi(300),
            widget = wibox.container.constraint,
        },
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 12)
        end,
        border_width = 0,
    }
end)

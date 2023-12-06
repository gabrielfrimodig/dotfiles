-- Required Libraries
local awful = require("awful")
local ruled = require("ruled")
local beautiful = require("beautiful")

ruled.notification.connect_signal('request::rules', function()
    -- Normal notifications
    ruled.notification.append_rule {
        rule       = { urgency = "normal" },
        properties = {
            screen       = awful.screen.preferred,
            position     = "top_right",
            height       = 120,
            width        = 400,
            border_color = beautiful.border_color,
            border_width = 2,
            spacing      = 10,
            opacity      = 0.8,
            bg           = beautiful.black,
            fg           = beautiful.fg_focus,
            timeout      = 5,
        }
    }

    -- Urgent notifications
    ruled.notification.append_rule {
        rule       = { urgency = "critical" },
        properties = {
            bg              = beautiful.fg_urgent,
            widget_template = {}
        }
    }
end)

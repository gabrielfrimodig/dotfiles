
-- Required Libraries
local awful = require ("awful")
local ruled = require ("ruled")
local gears = require ("gears")
local naughty = require ("naughty")
local wibox = require ("wibox")
local beautiful = require ("beautiful")

ruled.notification.connect_signal('request::rules', function()
    -- General rules
    ruled.notification.append_rule {
        rule        = { },
        properties  = {
            screen           = awful.screen.preferred,
            position         = "top_right",
            height           = 120,
            width            = 400,
            border_color     = beautiful.border_color,
            border_width     = 2,
            spacing          = 10,
            opacity          = 0.8,
        }
    }

    -- Urgent notifications
    ruled.notification.append_rule {
        rule        = { urgency = "critical" },
        properties  = {
            bg              = beautiful.fg_urgent,
            widget_template = {
            }
        }
    }

    -- Normal notifications
    ruled.notification.append_rule {
        rule       = { urgency = "normal" },
        properties = {
            bg               = beautiful.black,
            fg               = beautiful.fg_focus,
            timeout = 5,
        }
    }
end)

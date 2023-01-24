
-- Required Libraries
local awful = require ("awful")
local ruled = require ("ruled")
local gears = require ("gears")
local beautiful = require ("beautiful")

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule       = { },
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
            position         = "top_right",
            bg               = '#1e1e2e',
            fg               = '#ffffff',
            height           = 120,
            width            = 400,
            border_color     = "#000000",
            border_width     = 2,
            spacing          = 10,
            opacity          = 0.8,
        }
    }
end)


-- Required libraries
local awful = require("awful")
local ruled = require("ruled")
local beautiful = require("beautiful")

-- Connect to signal
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            buttons      = clientbuttons,
            focus        = awful.client.focus.filter,
            raise        = true,
            screen       = awful.screen.preferred,
            placement    = awful.placement.no_overlap + awful.placement.no_offscreen + awful.placement.centered
        }
    }

    -- Floating clients
    ruled.client.append_rule {
        id         = "floating",
        rule_any   = {
            instance = {
                "DTA",   -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry",
            },
            class    = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin", -- kalarm.
                "Sxiv",
                "Nitrogen",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer",
                "Alacritty",
                "Main",
                "gnome-calculator"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name     = {
                "Event Tester", -- xev.
            },
            role     = {
                "AlarmWindow",   -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    }

    -- Discord always map on tag "9" on screen 1.
    ruled.client.append_rule {
        rule       = { class = "discord" },
        properties = { screen = 1, tag = awful.screen.focused().tags[9] }
    }

    -- Spotify always map to tag "8" on screen 1.
    ruled.client.append_rule {
        rule       = { class = "Spotify" },
        properties = { screen = 1, tag = awful.screen.focused().tags[8] }
    }
end)

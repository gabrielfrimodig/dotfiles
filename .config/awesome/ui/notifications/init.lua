local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")

local helpers = require("helpers")

naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = dpi(30)
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.timeout = 5
naughty.config.defaults.title = "Notification"
naughty.config.defaults.position = "top_right"

local icon = wibox.widget.textbox()
icon.font = "Ubuntu Nerd Font 28"
icon.markup = '<span foreground="' .. beautiful.fg_widget1 .. '">󰨞</span>'

naughty.connect_signal("request::display", function(notify)
    local time = os.date "%H:%M:%S"

    notify.timeout = 10

    local appicon = notify.icon or notify.app_icon
    if not appicon then appicon = beautiful.notification_icon end

    local action_widget = {
        {
            {
                id = 'text_role',
                align = "center",
                valign = "center",
                widget = wibox.widget.textbox
            },
            left = dpi(6),
            right = dpi(6),
            widget = wibox.container.margin
        },
        widget = wibox.container.background
    }

    local actions = wibox.widget {
        notification = notify,
        base_layout = wibox.widget {
            --Space for notification
            spacing = dpi(8),
            layout = wibox.layout.flex.horizontal
        },
        widget_template = action_widget,
        style = { underline_normal = false, underline_selected = true },
        widget = naughty.list.actions
    }
    helpers.add_hover_cursor(actions, "hand1")

    naughty.layout.box {
        notification = notify,
        type = "notification",
        bg = "#00000000",
        fg = beautiful.fg_normal,
        widget_template = {
            {
                {
                    {
                        {
                            -- Left part
                            {
                                icon,
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
                                    font = "JetBrains Mono Bold 10",
                                    fg = beautiful.fg_focus,
                                },
                                {
                                    -- Custom Message Widget
                                    widget = wibox.widget.textbox,
                                    text = notify.message,
                                    font = "JetBrains Mono 9",
                                    fg = beautiful.fg_urgent,
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

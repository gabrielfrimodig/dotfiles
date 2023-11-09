local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Define colors
local bg_normal = beautiful.tasklist_bg_normal or "#00000000"
local bg_focus = beautiful.tasklist_bg_focus or "#00000000"
local text_color_normal = beautiful.tasklist_text_color_normal or "#aaaaaa"
local text_color_focus = beautiful.tasklist_text_color_focus or "#ffffff"

-- Define tasklist widget
local tasklist = function(s)
    return awful.widget.tasklist {
        screen = s,
        filter = function(c, scr)
            -- Shows only focused windows on the current screen and ignores hidden windows.
            return awful.widget.tasklist.filter.focused(c, scr) and not c.hidden
        end,
        buttons = awful.util.table.join(
            awful.button({}, 1, function(c)
                if c == client.focus then
                    c.minimized = true
                else
                    c:emit_signal("request::activate", "tasklist", {raise = true})
                end
            end),
            awful.button({}, 3, function()
                -- Right click: Open a list of all clients.
                awful.menu.client_list({theme = {width = 250}})
            end),
            awful.button({}, 4, function()
                -- Scroll up: Focus the previous client in the list.
                awful.client.focus.byidx(-1)
            end),
            awful.button({}, 5, function()
                -- Scroll down: Focus the next client in the list.
                awful.client.focus.byidx(1)
            end)
        ),
        layout = {
            spacing = 5,
            layout = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    id = "icon",
                    widget = awful.widget.clienticon,
                },
                id = "bg_role",
                widget = wibox.container.background,
            },
            -- Add margin to the widget
            margins = 2,
            widget = wibox.container.margin,
            -- Set the tasklist widget size to the size of the icon
            update_callback = function(self, c, index, objects)
                self:get_children_by_id("icon")[1].forced_width = 40
                self:get_children_by_id("icon")[1].forced_height = 40
            end,
            -- Highlight the widget when the application is in focus
            bg = function(_, _, c)
                if c == client.focus then
                    return bg_focus
                else
                    return bg_normal
                end
            end,
            -- Set text color for normal and focused windows
            fg = function(_, _, c)
                if c == client.focus then
                    return text_color_focus
                else
                    return text_color_normal
                end
            end,
        },
    }
end

return tasklist

-- Required libraries
local awful = require("awful")
local wibox = require("wibox")

-- The opacity of the icon changes depending on whether the client is in focus.
-- Clients in focus have full opacity (value of 1), making them stand out,
-- while unfocused clients have reduced opacity (value of 0.5), giving them a subdued appearance.
local function update_tasklist_item(self, c, index, objects)
    local icon_container = self:get_children_by_id("icon_container")[1]
    icon_container.forced_width = 40
    icon_container.forced_height = 40

    -- Change the opacity based on focus
    if client.focus == c then
        icon_container.opacity = 1
    else
        icon_container.opacity = 0.5
    end
end

-- This function creates a tasklist widget
-- It displays only visible clients on the screen.
-- The tasklist allows interaction with client windows:
--   - Left click on a client to toggle minimization or focus it.
--   - Right click to open a menu listing all active clients.
local tasklist = function(s)
    return awful.widget.tasklist {
        screen = s,
        filter = function(c, scr)
            -- Display all client tags on the tasklist
            return c.screen == scr and c:isvisible()
        end,
        buttons = awful.util.table.join(
        -- Left click to focus
            awful.button({}, 1, function(c)
                if c == client.focus then
                    c.minimized = true
                else
                    c:emit_signal("request::activate", "tasklist", { raise = true })
                end
            end),
            -- Right click: Open all active clients across all tags
            awful.button({}, 3, function()
                awful.menu.client_list({ theme = { width = 250 } })
            end)
        ),
        layout = {
            spacing = 2,
            layout = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    id = "icon",
                    widget = awful.widget.clienticon,
                },
                id = "icon_container",
                widget = wibox.container.background,
            },
            margins = 2,
            widget = wibox.container.margin,
            -- Set the tasklist widget size to the size of the icon
            update_callback = update_tasklist_item,
        },
    }
end

return tasklist

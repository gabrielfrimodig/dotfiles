-- Required libraries
local awful = require("awful")
local gears = require("gears")

-- Client mouse bindings
clientbuttons = gears.table.join(
    -- Left-click on a client to focus
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),

    -- Modkey + Left-click to move a client
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),

    -- Modkey + Right-click to resize a client
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Root window mouse bindings
root.buttons(gears.table.join(
    -- Right-click on the desktop to toggle the main menu
    awful.button({}, 3, function() mymainmenu:toggle() end),

    -- Scroll up / down to view previous / next tag
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))

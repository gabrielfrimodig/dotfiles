-- Required libraries
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local create_button = require("ui.powermenu.button")

local logout = create_button("󰍃", "Logout", "pkill Xorg", beautiful.fg_logout)
local sleep = create_button("󰤄", "Sleep", "systemctl suspend", beautiful.fg_sleep)
local lock = create_button("󰍁", "Lock", "i3lock", beautiful.fg_lock)
local reboot = create_button("󰑓", "Reboot", "reboot", beautiful.fg_reboot)
local shutdown = create_button("󰐥", "Shutdown", "shutdown now", beautiful.fg_shutdown)

local powermenu = awful.popup {
    screen = screen.primary,
    widget = {
        {
            widget = wibox.container.margin,
            margins = dpi(20)
        },
        widget = wibox.container.place,
    },
    ontop = true,
    visible = false,
    focus = false,
    placement = awful.placement.centered,
    minimum_width = awful.screen.focused().geometry.width,
    minimum_height = awful.screen.focused().geometry.height,
    maximum_width = awful.screen.focused().geometry.width,
    maximum_height = awful.screen.focused().geometry.height,
    shape = gears.shape.rectangle,
    bg = beautiful.bg_popup or beautiful.black
}

-- Icon as temporary profile_picture picture
local profile_picture = wibox.widget {
    markup = string.format('<span font="%s" foreground="%s">󰙃</span>', beautiful.powermenu_profile, beautiful.fg_profile),
    align = "center",
    widget = wibox.widget.textbox
}

local uptime_box = wibox.widget {
    text = "Loading...",
    font = beautiful.ubuntu_icon,
    widget = wibox.widget.textbox
}

-- This function updates the system uptime information.
-- It executes the 'uptime -p' command asynchronously to fetch the system's uptime.
-- The output from the command is then processed to extract the uptime information.
-- This extracted uptime is formatted and set as the text of the 'uptime_box' widget.
-- The 'uptime_box' widget thus displays the current system uptime in a readable format.
local function update_uptime()
    awful.spawn.easy_async("uptime -p", function(stdout)
        local uptime = stdout:match("up (.*)\n"):gsub("^%s*(.-)%s*$", "%1")
        uptime_box.text = "Uptime: " .. uptime
    end)
end

local uptime_timer = gears.timer({
    timeout = 60,
    call_now = true,
    autostart = true,
    callback = update_uptime
})

local button_spacer = wibox.widget {
    forced_width = dpi(25),
    layout = wibox.layout.fixed.horizontal
}

local vertical_spacer = wibox.widget {
    forced_height = dpi(10),
    layout = wibox.layout.fixed.vertical
}

powermenu:setup {
    {
        {
            profile_picture,
            {
                uptime_box,
                layout = wibox.container.place
            },
            vertical_spacer,
            {
                logout,
                button_spacer,
                sleep,
                button_spacer,
                lock,
                button_spacer,
                reboot,
                button_spacer,
                shutdown,
                layout = wibox.layout.fixed.horizontal
            },
            layout = wibox.layout.fixed.vertical
        },
        layout = wibox.container.place
    },
    widget = wibox.container.background,
}

local powermenu_esc = awful.keygrabber {
    autostart = false,
    stop_event = "release",
    keypressed_callback = function(self, mod, key, command)
        if key == 'Escape' or key == 'q' then
            awesome.emit_signal("module::powermenu:hide")
        end
    end
}

awesome.connect_signal(
    "module::powermenu:show",
    function()
        powermenu.visible = true
        powermenu_esc:start()
    end
)

awesome.connect_signal(
    "module::powermenu:hide",
    function()
        powermenu.visible = false
        powermenu_esc:stop()
    end
)

return powermenu

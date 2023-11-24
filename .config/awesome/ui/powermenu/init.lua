-- Required libraries
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local create_button = require("ui.powermenu.button")

local logout = create_button("󰍃", "Logout", "pkill Xorg", beautiful.pink)
local sleep = create_button("󰤄", "Sleep", "systemctl suspend", beautiful.red)
local lock = create_button("󰍁", "Lock", "i3lock", beautiful.peach)
local reboot = create_button("󰑓", "Reboot", "reboot", beautiful.yellow)
local shutdown = create_button("󰐥", "Shutdown", "shutdown now", beautiful.green)

local powermenu = awful.popup {
    screen = s,
    widget = {
        {
            powermenu_layout,
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
    bg = "#ff000000" or beautiful.bg_normal,
}

-- Icon as temporary profile_picture picture
local profile_picture = wibox.widget {
    markup = '<span font="Ubuntu Nerd Font 140" foreground="' .. beautiful.lavender .. '">' .. "󰙃" .. '</span>',
    align = "center",
    widget = wibox.widget.textbox
}

local uptime_box = wibox.widget {
    text = "Loading...",
    font = beautiful.ubuntu_icon,
    widget = wibox.widget.textbox
}

-- Update uptime
local function update_uptime()
    awful.spawn.easy_async("uptime -p", function(stdout)
        local uptime = stdout:match("up (.*)\n"):gsub("^%s*(.-)%s*$", "%1")
        uptime_box.text = "Uptime: " .. uptime
    end)
end

-- Timer to update uptime every minute
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
            {
                text,
                widget = wibox.container.margin,
            },
            layout = wibox.layout.fixed.vertical
        },
        layout = wibox.container.place
    },
    widget = wibox.container.background,
}

local powermenu_esc = awful.keygrabber {
    autostart = false,
    stop_event = 'release',
    keypressed_callback = function(self, mod, key, command)
        if key == 'Escape' then
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

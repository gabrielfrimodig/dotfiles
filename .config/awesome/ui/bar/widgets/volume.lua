-- Required libraries
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local watch = require("awful.widget.watch")

local volume = wibox.widget.textbox()
volume.font = beautiful.font

local volume_icon = wibox.widget.textbox()

local volume_icon_popup = wibox.widget {
    markup = '<span font="Ubuntu Nerd Font 110" foreground="' .. beautiful.white .. '">' .. "󰕾" .. '</span>',
    align = "center",
    widget = wibox.widget.textbox
}

local volume_widget = wibox.widget {
    {
        layout = wibox.layout.fixed.horizontal,
        volume_icon,
        {
            volume,
            fg = beautiful.fg_widget1,
            widget = wibox.container.background
        },
    },
    spacing = dpi(1),
    layout = wibox.layout.fixed.horizontal,
}

local volume_slider = wibox.widget {
    bar_shape = gears.shape.rounded_rect,
    bar_height = dpi(3),
    bar_color = beautiful.white,
    handle_color = beautiful.white,
    handle_shape = gears.shape.circle,
    handle_width = dpi(15),
    handle_border_width = dpi(1),
    handle_border_color = beautiful.border_color,
    value = 50,
    maximum = 100,
    forced_height = dpi(20),
    forced_width = dpi(140),
    widget = wibox.widget.slider
}

local volume_popup = awful.popup {
    screen = screen.primary,
    widget = {
        {
            widget = wibox.container.margin,
            margins = dpi(20),
        },
        widget = wibox.container.place,
    },
    ontop = true,
    visible = false,
    focus = false,
    placement = awful.placement.centered,
    shape = gears.shape.rounded_rect,
    bg = beautiful.bg_popup or beautiful.black,
}

local popup_timer = gears.timer {
    timeout = 2,
    single_shot = true,
    callback = function()
        volume_popup.visible = false
    end
}

local volume_slider_with_margins = wibox.container.margin(volume_slider, dpi(40), dpi(40), dpi(0), dpi(20))

local function get_current_audio_output_device()
    local handle = io.popen("pactl list sinks")
    local result = handle:read("*a")
    handle:close()

    for line in result:gmatch("[^\r\n]+") do
        if line:find("Active Port:") then
            local port = line:match("Active Port: (.+)")
            if port and port:find("headphones") then
                return "headphones"
            else
                return "speakers"
            end
        end
    end

    return "unknown"
end


local function set_icon(is_muted)
    local device = get_current_audio_output_device()
    local icon

    if is_muted == "true" and device == "headphones" then
        icon = "󰟎"
    elseif is_muted == "true" then
        icon = "󰖁"
    elseif device == "headphones" then
        icon = "󰋋"
    else
        icon = "󰕾"
    end

    -- Update the volume_icon markup
    volume_icon.markup = string.format('<span font="Ubuntu Nerd Font 14" foreground="%s">%s</span>',
        beautiful.fg_widget1, icon)

    -- Update the volume_icon_popup markup with different style
    volume_icon_popup.markup = string.format('<span font="Ubuntu Nerd Font 110" foreground="%s">%s</span>',
        beautiful.white, icon)
end

volume_popup:setup {
    {
        {
            volume_icon_popup,
            {
                volume_slider_with_margins,
                widget = wibox.container.margin,
            },
            layout = wibox.layout.fixed.vertical
        },
        layout = wibox.container.place
    },
    widget = wibox.container.background,
}

volume:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then awful.spawn("pamixer --toggle-mute") end
end)

local function update_volume_widget()
    awful.spawn.easy_async("pamixer --get-volume --get-mute", function(stdout)
        local is_muted, volume_level = stdout:match("(%a+)%s(%d+)")
        if volume_level then
            volume.text = ' ' .. volume_level .. '%'
            volume_slider.value = tonumber(volume_level)
            if tonumber(volume_level) >= 90 then
                volume_slider.bar_color = beautiful.red
                volume_slider.handle_color = beautiful.red
            elseif tonumber(volume_level) >= 70 then
                volume_slider.bar_color = beautiful.bar_warning
                volume_slider.handle_color = beautiful.bar_warning
            else
                volume_slider.bar_color = beautiful.white
                volume_slider.handle_color = beautiful.white
            end
        end
        set_icon(is_muted)
    end)
end

local function show_volume_popup()
    volume_popup.visible = true
    popup_timer:start()
end

awesome.connect_signal("volume::increase", function()
    awful.spawn("pamixer --increase 5", false)
    update_volume_widget()
    show_volume_popup()
end)

awesome.connect_signal("volume::decrease", function()
    awful.spawn("pamixer --decrease 5", false)
    update_volume_widget()
    show_volume_popup()
end)

awesome.connect_signal("volume::mute", function()
    awful.spawn("pamixer --toggle-mute", false)
    update_volume_widget()
    show_volume_popup()
end)

watch("pamixer --get-volume --get-mute", 1, function()
    update_volume_widget()
    collectgarbage("collect")
end)

return volume_widget

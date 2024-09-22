-- Required libraries
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local layout_list = awful.widget.layoutlist {
    base_layout = wibox.widget {
        spacing = dpi(4),
        forced_num_cols = 5,
        layout = wibox.layout.grid.vertical,
    },
    widget_template = {
        {
            {
                id = 'icon_role',
                widget = wibox.widget.imagebox,
            },
            margins = dpi(4),
            widget = wibox.container.margin,
        },
        id = 'background_role',
        forced_width = dpi(76),
        forced_height = dpi(80),
        shape = gears.shape.rounded_rect,
        widget = wibox.container.background,
    },
    style = {
        shape_border_width_selected = dpi(2),
        shape_selected = gears.shape.rounded_rect,
        shape_border_color_selected = beautiful.white
    },
}

local layout_popup = awful.popup {
    widget = wibox.widget {
        layout_list,
        margins = dpi(12),
        widget = wibox.container.margin,
    },
    bg = beautiful.bg_popup or beautiful.black,
    border_width = dpi(2),
    placement = awful.placement.centered,
    shape = gears.shape.rounded_rect,
    ontop = true,
    visible = false,
}

local popup_timer = gears.timer {
    timeout = 2, -- Time before the popup hides automatically
    single_shot = true,
    callback = function()
        layout_popup.visible = false
    end
}

local function show_layout_popup()
    layout_popup.screen = awful.screen.focused()
    layout_popup.visible = true
    popup_timer:start()
end

tag.connect_signal("property::layout", function()
    show_layout_popup()
end)

return layout_popup

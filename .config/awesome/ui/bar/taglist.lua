-- Required libraries
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Each screen has its own tag table.
screen.connect_signal("request::desktop_decoration", function(s)
  awful.tag({ "󰅬", "", "󰨞", "", "", "󰅩", "󰊢", "", "󰻝" }, s, awful.layout.layouts[1])
end)

local button = awful.button({}, 1, function(t) t:view_only() end)

-- Function to create a taglist widget for each screen in AwesomeWM.
-- This function sets up a taglist for each screen connected to the system.
-- The taglist dynamically changes the color of each tag based on whether it contains any windows.
-- @param s The screen for which the taglist is being created.
-- @return A taglist widget configured for the provided screen.
return function(s)
  local tag = awful.widget.taglist {
    screen          = s,
    filter          = awful.widget.taglist.filter.all,
    buttons         = button,
    layout          = {
      spacing = dpi(14),
      layout = wibox.layout.fixed.horizontal,
    },
    style           = {
      font = beautiful.widget_icon,
    },
    widget_template = {
      {
        id     = "text_role",
        widget = wibox.widget.textbox,
      },
      widget = wibox.container.background,
      id = "background_role",
      create_callback = function(self, t, index, objects)
        -- Initial color setting, when the widget is created
        if #t:clients() == 0 then
          self:get_children_by_id("background_role")[1].fg = beautiful.gray
        else
          self:get_children_by_id("background_role")[1].fg = beautiful.tags[t.index]
        end
      end,
      update_callback = function(self, t, index, objects)
        -- Update the color, whenever the tag is updated
        if #t:clients() == 0 then
          self:get_children_by_id("background_role")[1].fg = beautiful.gray
        else
          self:get_children_by_id("background_role")[1].fg = beautiful.tags[t.index]
        end
      end,
    }
  }

  return tag
end

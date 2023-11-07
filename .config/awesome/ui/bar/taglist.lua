
-- Required libraries
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Each screen has its own tag table.
screen.connect_signal("request::desktop_decoration", function(s)
    awful.tag({ "󰅬 ", " ", "󰨞 ", " ", " ", "󱞙 ", " ", " ", " "}, s, awful.layout.layouts[1])
end)

local button = awful.button({ }, 1, function(t) t:view_only() end)

return function(s)
  local tag = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = button,
    layout   = {
      spacing = dpi(8),
      layout = wibox.layout.fixed.horizontal,
    },
    style = {
      font = beautiful.font_icon,
      spacing = dpi(10),
      fg_focus = beautiful.green,
      fg_occupied = beautiful.red,
      fg_empty = beautiful.tags_col[tag.index],
    },
  }

  return tag
end

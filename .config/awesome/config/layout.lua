-- Required libraries
local awful = require("awful")

-- Comment or uncommen for layouts of your choice.
awful.layout.layouts = {
    awful.layout.suit.tile.left,
    awful.layout.suit.floating,
    awful.layout.suit.fair,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.magnifier,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.corner.nw,
}

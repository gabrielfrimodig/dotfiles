-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.autofocus")

-- Standard awesome library
local awful = require("awful")
local beautiful = require("beautiful")

-- Theme handling library
local themes = {
    "catppuccino",
    "gruvbox",
    "seashell",
}

local chosen_theme = themes[1]

beautiful.init(string.format("%s/.config/awesome/theme/%s/theme.lua", os.getenv("HOME"), chosen_theme))

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Modkey: Mod4 (Super key) or Mod1 (Alt key)
modkey = "Mod4"

require 'signals'

require 'bindings'

require 'config'

require 'rules'

require 'ui'

-- Autostart
awful.spawn.with_shell(string.format("%s/.config/awesome/autostart.sh", os.getenv("HOME")))

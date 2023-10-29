-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
require("awful.autofocus")

-- Awesome library
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")

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
awful.spawn.with_shell("picom")
awful.spawn.with_shell("feh --bg-scale ~/Pictures/Wallpaper/wallpaper.jpg")

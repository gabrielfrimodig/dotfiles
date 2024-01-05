-- Required libraries
local theme_assets        = require("beautiful.theme_assets")
local xresources          = require("beautiful.xresources")
local gears               = require("gears")
local dpi                 = xresources.apply_dpi

local gfs                 = require("gears.filesystem")
local themes_path         = gfs.get_themes_dir()

local theme               = {}

theme.widget_text         = "JetBrains Mono 10"
theme.notification_bold   = "JetBrains Mono Bold 10"
theme.notification_text   = "JetBrains Mono 10"
theme.powermenu_button    = "Ubuntu Nerd Font 10"
theme.widget_icon         = "Ubuntu Nerd Font 14"
theme.popup_icon          = "Ubuntu Nerd Font 110"
theme.widget_icon_battery = "Ubuntu Nerd Font 12"
theme.powermenu_icon      = "Ubuntu Nerd Font Bold 20"
theme.powermenu_profile   = "Ubuntu Nerd Font 140"

theme.font_u              = "Ubuntu Nerd Font 12"
theme.ubuntu_icon         = "Ubuntu Nerd Font 14"
theme.popup_icon          = "Ubuntu Nerd Font 110"

--[[
    This theme is based on Catpuccin Mocha

    https://github.com/catppuccin/catppuccin

    Available colors:

    rosewater  = "#f5e0dc"
    flamingo   = "#f2cdcd"
    pink       = "#f5c2e7"
    mauve      = "#cba6f7"
    red        = "#f38ba8"
    maroon     = "#eba0ac"
    peach      = "#fab387"
    yellow     = "#f9e2af"
    green      = "#a6e3a1"
    teal       = "#94e2d5"
    sky        = "#89dceb"
    sapphire   = "#74c7ec"
    blue       = "#89b4fa"
    lavender   = "#b4befe"
    white      = "#cdd6f4"
    subtext1   = "#bac2de"
    subtext0   = "#a6adc8"
    overlay2   = "#9399b2"
    overlay1   = "#7f849c"
    overlay0   = "#6c7086"
    surface2   = "#585b70"
    surface1   = "#45475a"
    surface0   = "#313244"
    base       = "#1e1e2e"
    mantle     = "#181825"
    crust      = "#11111b"
]]

-- Bar widgets
theme.black                    = "#1e1e2e"
theme.gray                     = "#6c7086"
theme.orange                   = "#fab387"
theme.red                      = "#f38ba8"
theme.white                    = "#cdd6f4"

theme.fg_volume                = "#f5c2e7"
theme.fg_brightness            = "#f38ba8"
theme.fg_battery               = "#cba6f7"
theme.fg_cpu                   = "#f38ba8"
theme.fg_ram                   = "#f5c2e7"
theme.fg_wifi                  = "#fab387"
theme.fg_date                  = "#f9e2af"
theme.fg_clock                 = "#a6e3a1"

theme.border_color             = "#1e1e2e"
theme.bg_bar                   = "#1e1e2e"
theme.button_focus             = "#535d6c"
theme.bg_tooltip               = "#00000033"
theme.bg_popup                 = "#00000033"

theme.fg_profile               = "#b4befe"
theme.fg_logout                = "#f5c2e7"
theme.fg_sleep                 = "#f38ba8"
theme.fg_lock                  = "#fab387"
theme.fg_reboot                = "#f9e2af"
theme.fg_shutdown              = "#a6e3a1"

-- Taglist
theme.tags                     = {
    "#f5c2e7",
    "#cba6f7",
    "#f38ba8",
    "#eba0ac",
    "#fab387",
    "#f9e2af",
    "#89b4fa",
    "#a6e3a1",
    "#f5c2e7",
}

theme.taglist_fg_focus         = theme.white

-- Systray
theme.bg_systray               = theme.black

-- Hotkeys
theme.hotkeys_bg               = theme.bg_popup
theme.hotkeys_fg               = theme.white
theme.hotkeys_border_width     = dpi(0)
theme.hotkeys_modifiers_fg     = theme.fg_widget2
theme.hotkeys_label_bg         = theme.button_focus
theme.hotkeys_label_fg         = theme.fg_focus
theme.hotkeys_font             = theme.font
theme.hotkeys_description_font = theme.font
theme.hotkeys_group_margin     = dpi(20)

-- Rounded Hotkeys
theme.hotkeys_shape            = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, dpi(12))
end

-- Menu
theme.menu_submenu_icon        = themes_path .. "default/submenu.png"
theme.menu_bg_normal           = "#00000080"
theme.menu_fg_normal           = theme.gray
theme.menu_fg_focus            = theme.white
theme.menu_height              = dpi(15)
theme.menu_width               = dpi(140)

-- You can use your own layout icons like this:
theme.layout_fairh             = os.getenv("HOME") .. "/.config/awesome/theme/catppuccino/layouts/fairhw.png"
theme.layout_fairv             = os.getenv("HOME") .. "/.config/awesome/theme/catppuccino/layouts/fairvw.png"
theme.layout_floating          = os.getenv("HOME") .. "/.config/awesome/theme/catppuccino/layouts/floatingw.png"
theme.layout_magnifier         = os.getenv("HOME") .. "/.config/awesome/theme/catppuccino/layouts/magnifierw.png"
theme.layout_max               = os.getenv("HOME") .. "/.config/awesome/theme/catppuccino/layouts/maxw.png"
theme.layout_fullscreen        = os.getenv("HOME") .. "/.config/awesome/theme/catppuccino/layouts/fullscreenw.png"
theme.layout_tilebottom        = os.getenv("HOME") .. "/.config/awesome/theme/catppuccino/layouts/tilebottomw.png"
theme.layout_tileleft          = os.getenv("HOME") .. "/.config/awesome/theme/catppuccino/layouts/tileleftw.png"
theme.layout_tile              = os.getenv("HOME") .. "/.config/awesome/theme/catppuccino/layouts/tilew.png"
theme.layout_tiletop           = os.getenv("HOME") .. "/.config/awesome/theme/catppuccino/layouts/tiletopw.png"
theme.layout_spiral            = os.getenv("HOME") .. "/.config/awesome/theme/catppuccino/layouts/spiralw.png"
theme.layout_dwindle           = os.getenv("HOME") .. "/.config/awesome/theme/catppuccino/layouts/dwindlew.png"
theme.layout_cornernw          = os.getenv("HOME") .. "/.config/awesome/theme/catppuccino/layouts/cornernww.png"
theme.layout_cornerne          = os.getenv("HOME") .. "/.config/awesome/theme/catppuccino/layouts/cornernew.png"
theme.layout_cornersw          = os.getenv("HOME") .. "/.config/awesome/theme/catppuccino/layouts/cornersww.png"
theme.layout_cornerse          = os.getenv("HOME") .. "/.config/awesome/theme/catppuccino/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon             = theme_assets.awesome_icon(
    theme.menu_height, "#535d6c", theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme               = nil

return theme


# .dotfiles

<div align="center">
    <p><strong>There's no place like <code>~</code>!</strong></p>
</div>

<div align="center">
    <img src="https://i.imgur.com/rwlsX3b.png" />
</div>

<div align="center">

[Information](#memo-information) • [Latest Updates](#bell-latest-updates) • [Future Plans](#hammer-future-plans) • [Installation](#wrench-installation) • [Gallery](#camera-gallery) • [Features](#bulb-features) • [Dependencies](#inbox_tray-dependencies) • [Keybindings](#musical_keyboard-keybindings) • [Structure](#evergreen_tree-structure) • [Credits](#sparkling_heart-credits) • [License](#scroll-license)

</div>

## Welcome to my AwesomeWM configurations

<a href="https://awesomewm.org/"><img alt="AwesomeWM" height="160" align = "left" src="https://awesomewm.org/doc/api/images/AUTOGEN_wibox_logo_logo_and_name.svg"></a>

[AwesomeWM](https://awesomewm.org/) is a highly configurable, next generation tiling window manager for X. It is renowned for its extensibility and its dynamic window management capabilities, which are powered by the Lua programming language.

Welcome to my AwesomeWM configuration repository! This setup is crafted to create a productive and visually appealing desktop environment using the AwesomeWM. It's designed to be elegant, allowing for quick navigation and organization of the workspace with a sleek, minimalist aesthetic.

Dive into the configuration files to discover a realm of efficiency and customization. Whether you're new to AwesomeWM or a seasoned enthusiast, I hope this repository serves as both a resource and inspiration for your own configurations.

Enjoy making your desktop truly your own!

## :memo: Information

- **OS:** Fedora Workstation
- **File manager:** Thunar
- **Terminal:** Kitty
- **Shell:** zsh
- **Launcher:** Rofi
- **Screenshot:** maim
- **Browser:** Brave
- **Editor:** Neovim / VSCode

## :bell: Latest Updates

- Rofi configuration
- New Layout icons
- Tags opacity
- Popups for brightness, volume and microphone
- Powermenu implementation
- New icons for bar (Material Design Icon)

## :hammer: Future Plans

- Add `gruvbox` and `seashell` themes option.
- Improve the awesome menu (mouse right click).
- Icon support for bluetooth headphones.
- Installtion script ([Issue #12](https://github.com/gabrielfrimodig/dotfiles/issues/12)).
- Layout display popup when changed.

## :wrench: Installation


1. Install [git version of AwesomeWM](https://github.com/awesomeWM/awesome/)

    Follow the build instructions [here](https://github.com/awesomeWM/awesome/#building-and-installation).


2. Clone this repository

    ```bash
    git clone https://github.com/gabrielfrimodig/dotfiles.git
    ```

3. Copy the configuration files to the correct directory

    ```bash
    cp -r dotfiles/.config/awesome ~/.config/
    ```

4. Install dependencies

    See [Dependencies](#inbox_tray-dependencies).

5. Restart AwesomeWM

    ```bash
    awesome -r
    ```

6. Enjoy!

## :camera: Gallery

<div align="center">
    <em>Powermenu</em>
    <br>
    <img width="600px" src="https://i.imgur.com/Kpq8Nqa.png" alt="Powermenu" />
</div>

<div align="center">
    <em>Rofi menu</em>
    <br>
    <img width="600px" src="https://i.imgur.com/VTes4VI.png" alt="Widgets" />
</div>

<div align="center">
    <em>Wifi-tooltip (mouse hover)</em>
    <br>
    <img width="200px" src="https://i.imgur.com/cnlQbm3.png" alt="Wifi-tooltip" />
</div>

<div align="center">
    <em>Colorful tags</em>
    <br>
    <img width="400px" src="https://i.imgur.com/IePmE0e.png" alt="Tags" />
</div>

<div align="center">
    <em>Wibar widgets</em>
    <br>
    <img width="800px" src="https://i.imgur.com/WlEMHPr.png" alt="Widgets" />
</div>

<div align="center">
    <em>Different popups</em>
    <br>
    <img widget="180px" src="https://i.imgur.com/gqgsKbu.png" alt="Popups" />
    <br>
    <img width="180px" src="https://i.imgur.com/dGz9kVO.png" alt="Popups" />
    <img width="180px" src="https://i.imgur.com/faPD0ra.png" alt="Popups" />
    <br>
    <img width="160px" src="https://i.imgur.com/dyEd3fN.png" alt="Popups" />
    <img width="160px" src="https://i.imgur.com/X4tx3JH.png" alt="Popups" />
</div>

## :bulb: Features

- **Client in focus:** The client in focus is highlighted while the other are somewhat opaque.

<div align="center">
    <img width="200px" src="https://i.imgur.com/chCfd25.png" alt="Widgets" />
    <br>
    <em>Kitty terminal in focus.</em>
</div>

- **Urgent:** Urgent tags will be red.
- **Battery:** Battery icon will dynamically change based on status.
- **Popups:** Popup will be shown when either brightness, volume or microphone status is changed.

- **Wallpaper:** Set wallpaper with `feh` in `autostart.sh`.
  <details>
  <summary><code>autostart.sh</code></summary>

  ```bash
  feh --bg-fill ~/Pictures/wallpapers/1.jpg
  ```

  </details>
- **Mapping:** Spotify maps to tag 8, screen 1, Discord maps to tag 9, screen 1.
  <details>
  <summary><code>rules/init.lua</code></summary>

  ```lua
    ruled.client.append_rule {
        rule       = { class = "discord" },
        properties = { screen = 1, tag = awful.screen.focused().tags[9] }
    }

    ruled.client.append_rule {
        rule       = { class = "Spotify" },
        properties = { screen = 1, tag = awful.screen.focused().tags[8] }
    }
    ```

    </details>
- **Screenshot:** Will be saved at `~/Pictures/Screenshots/` with timestamp provided by the OS.
  <details>
  <summary><code>bindings/keyboard.lua</code></summary>

  ```lua
    awful.key({}, "Print", function()
        local home = os.getenv("HOME")
        local filepath = home .. "/Pictures/Screenshots/" .. os.date("%Y-%m-%d_%H:%M:%S") .. ".png"
        awful.spawn.with_shell('maim -u ' .. filepath)
        naughty.notify({
            icon = filepath,
            title = "Screenshot taken",
            text = filepath
        })
    end, { description = "screen screenshot", group = "launcher" }),
    awful.key({ "Shift" }, "Print", function()
        local home = os.getenv("HOME")
        local filepath = home .. "/Pictures/Screenshots/" .. os.date("%Y-%m-%d_%H:%M:%S") .. ".png"
        awful.spawn.with_shell('maim -s --format png -u ' .. filepath .. '| xclip -selection clipboard -t image/png -i')
        naughty.notify({
            icon = filepath,
            title = "Select Area for Screenshot",
            text = "Screenshot will be saved"
        })
    end, { description = "screenshot area", group = "launcher" }),
  ```

  </details>
- Neovim configuration is [here](https://github.com/gabrielfrimodig/neovim).
- Multi-screen support

## :inbox_tray: Dependencies

- **AwesomeWM:** [Git version](https://github.com/awesomeWM/awesome) is required
- **Picom:** [yshui/picom](https://github.com/yshui/picom)
- **feh:** For setting wallpaper
- **rofi:** Application launcher
- **Pamixer:** Managing sound and mic
- **acpi:** Battery Information 
- **xbacklight:** Screen brightness
- **maim:** Screenshot tool
  - **xclip:** Copying screenshots to clipboard
  - The folder `~/Pictures/Screenshots/` must exists for screenshots to be saved.
- **playerctl:** Media player control
- **Fonts:**
  - **Icons:** [Material Design Icons](https://pictogrammers.com/)
  - **AwesomeWM:** `JetBrains Mono` and `Ubuntu Nerd Font`
- **Autostart.sh** Needs permission change to work properly
  ```bash
  chmod +x autostart.sh
  ```

## :musical_keyboard: Keybindings

Find the detailed keybinding list on the [wiki page](https://github.com/gabrielfrimodig/dotfiles/wiki/Keybindings).

## :evergreen_tree: Structure

<details>
<summary><code>tree ~/.config/awesome</code></summary>

```markdown
.
├── autostart.sh
├── bindings
│   ├── init.lua
│   ├── keyboard.lua
│   └── mouse.lua
├── config
│   ├── gaps.lua
│   ├── init.lua
│   ├── layout.lua
│   ├── menu.lua
│   └── signals.lua
├── rc.lua
├── rules
│   └── init.lua
├── signals
│   ├── brightness.lua
│   ├── corners.lua
│   ├── error.lua
│   ├── init.lua
├── theme
│   ├── catppuccino
│   │   ├── layouts
│   │   │   ├── cornernew.png
│   │   │   ├── cornernww.png
│   │   │   ├── cornersew.png
│   │   │   ├── cornersww.png
│   │   │   ├── dwindlew.png
│   │   │   ├── fairhw.png
│   │   │   ├── fairvw.png
│   │   │   ├── floatingw.png
│   │   │   ├── fullscreenw.png
│   │   │   ├── magnifierw.png
│   │   │   ├── maxw.png
│   │   │   ├── spiralw.png
│   │   │   ├── tilebottomw.png
│   │   │   ├── tileleftw.png
│   │   │   ├── tiletopw.png
│   │   │   └── tilew.png
│   │   └── theme.lua
└── ui
    ├── bar
    │   ├── init.lua
    │   ├── layoutbox.lua
    │   ├── taglist.lua
    │   ├── tasklist.lua
    │   └── widgets
    │       ├── battery.lua
    │       ├── brightness.lua
    │       ├── clock.lua
    │       ├── cpu.lua
    │       ├── date.lua
    │       ├── memory.lua
    │       ├── volume.lua
    │       └── wifi.lua
    ├── init.lua
    ├── notifications
    │   └── init.lua
    ├── popups
    │   └── mic.lua
    └── powermenu
        ├── button.lua
        └── init.lua
```

</details>

## :sparkling_heart: Credits

Inspiration taken from [this reddit post](https://www.reddit.com/r/unixporn/comments/yxlylm/dwm_i_heard_catppuccin_is_the_new_cool/?utm_source=share&utm_medium=web2x&context=3).

**AwesomeWM inspirational sources:**
- [pablonoya/awesomewm-configuration](https://github.com/pablonoya/awesomewm-configuration)

## :scroll: License

This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/gabrielfrimodig/dotfiles/blob/master/LICENSE) file for details.

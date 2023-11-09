
# .dotfiles

<div align="center">
    <p><strong>There's no place like <code>~</code>!</strong></p>
</div>

<div align="center">
    <img width="600px" src="https://i.imgur.com/mxXNwjd.png" />
</div>

<div align="center">

[Information](#memo-information) • [Latest Updates](#bell-latest-updates) • [Installation](#wrench-installation) • [Gallery](#camera-gallery) • [Features](#bulb-features) • [Dependencies](#inbox_tray-dependencies) • [Keybindings](#musical_keyboard-keybindings) • [Structure](#evergreen_tree-structure) • [Credits](#sparkling_heart-credits) • [License](#scroll-license)

</div>

## Welcome to my AwesomeWM configurations

<a href="https://awesomewm.org/"><img alt="AwesomeWM" height="160" align = "left" src="https://awesomewm.org/doc/api/images/AUTOGEN_wibox_logo_logo_and_name.svg"></a>

[AwesomeWM](https://awesomewm.org/) is a highly configurable, next generation tiling window manager. It is renowned for its extensibility and its dynamic window management capabilities, which are powered by the Lua programming language.

Welcome to my AwesomeWM configuration repository! This setup is crafted to create a productive and visually appealing desktop environment using the AwesomeWM. It's designed to streamline your workflow, allowing for quick navigation and organization of your workspace with a sleek, minimalist aesthetic.

Dive into the configuration files to discover a realm of efficiency and customization. Whether you're new to AwesomeWM or a seasoned enthusiast, I hope this repository serves as both a resource and inspiration for your own configurations.

Enjoy making your desktop truly your own!

## :memo: Information

- **OS**: Fedora Workstation
- **File manager**: Thunar
- **Terminal**: Kitty
- **Shell**: zsh
- **Launcher**: Rofi
- **Browser**: Brave
- **Editor**: Neovim / VSCode

## :bell: Latest Updates

- New icons for bar (Material Design Icon)
- Assign color for each tag
- Hover option on date-module and wifi-module with signal strength
- Fixed volume error #9
- New keybindings

## :wrench: Installation

TODO: Add dependencies and fix installation script (Issue #12).

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

    Fedora:

    ```bash
    sudo dnf install picom feh rofi i3lock
    ```

5. Restart AwesomeWM

    ```bash
    awesome -r
    ```

6. Enjoy!

## :camera: Gallery

TODO: *Add some screenshots*

## :bulb: Features

TODO: A list of features and modules that make this configuration unique.

## :inbox_tray: Dependencies

- **AwesomeWM**: [Git version](https://github.com/awesomeWM/awesome) is required
- **Picom**
- **feh**: For setting wallpaper
- **rofi**: Application launcher
- *TODO: Add more dependencies*

## :musical_keyboard: Keybindings

Find the detailed keybinding list on the [wiki page](https://github.com/gabrielfrimodig/dotfiles/wiki/Keybindings).

## :evergreen_tree: Structure

<details>
<summary><code>tree ~/.config/awesome</code></summary>

```markdown
.
├── bindings
│   ├── init.lua
│   ├── keyboard.lua
│   └── mouse.lua
├── config
│   ├── gaps.lua
│   ├── init.lua
│   ├── layout.lua
│   ├── menu.lua
│   └── signals.lua
├── rc.lua
├── rules
│   └── init.lua
├── signals
│   ├── corners.lua
│   ├── error.lua
│   ├── init.lua
│   └── notifications.lua
├── theme.lua
└── ui
    ├── bar
    │   ├── init.lua
    │   ├── layoutbox.lua
    │   ├── taglist.lua
    │   └── widgets
    │       ├── battery.lua
    │       ├── brightness.lua
    │       ├── clock.lua
    │       ├── cpu.lua
    │       ├── date.lua
    │       ├── memory.lua
    │       ├── volume.lua
    │       └── wifi.lua
    └── init.lua
```

</details>

## :sparkling_heart: Credits

Inspiration taken from [this reddit post](https://www.reddit.com/r/unixporn/comments/yxlylm/dwm_i_heard_catppuccin_is_the_new_cool/?utm_source=share&utm_medium=web2x&context=3).

## :scroll: License

This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/gabrielfrimodig/dotfiles/blob/master/LICENSE) file for details.


# .dotfiles

<div align="center">
    <p>There's no place like <b><code>~</code></b> !</p>
</div>

<img src="https://i.imgur.com/Ewe9XO8.png" />

## AwesomeWM

<details>
<summary><code>tree ~/.config/awesome</code></summary>

```markdown
.
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
│   ├── corners.lua
│   ├── error.lua
│   ├── init.lua
│   └── notifications.lua
├── theme.lua
└── ui
    ├── bar
    │   ├── init.lua
    │   ├── layoutbox.lua
    │   ├── taglist.lua
    │   └── widgets
    │       ├── battery.lua
    │       ├── bluetooth.lua
    │       ├── brightness.lua
    │       ├── clock.lua
    │       ├── cpu.lua
    │       ├── date.lua
    │       ├── memory.lua
    │       ├── power.lua
    │       ├── volume.lua
    │       └── wifi.lua
    └── init.lua
```
</details>

<details>
<summary>Dependencies</summary>

This configuration requires the use of the git version of [awesome](https://github.com/awesomeWM/awesome). \
*TODO*
</details>

Inspiration taken from [this reddit post](https://www.reddit.com/r/unixporn/comments/yxlylm/dwm_i_heard_catppuccin_is_the_new_cool/?utm_source=share&utm_medium=web2x&context=3).

## Neovim
Plugin manager is [packer.nvim](https://github.com/wbthomason/packer.nvim).

| Plugin                                                                                | Module            |
| ------------------------------------------------------------------------------------- | ------------------|
| [Blankline](https://github.com/lukas-reineke/indent-blankline.nvim)                   | Blankline         |
| [Feline](https://github.com/feline-nvim/feline.nvim)                                  | Feline            |
| [Nightfox](https://github.com/EdenEast/nightfox.nvim)                                 | Nightfox          |

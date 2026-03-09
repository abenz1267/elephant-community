## niri keybinds

### Installation

- Copy `keybinds.lua` to `~/.config/elephant/menus/keybinds.lua`

If you want it to be displayed in 2 columns (recommended), add this to
`~/.config/walker/config.toml`:

```ini
[columns]
"menus:keybinds" = 2
```

### Usage

```kdl
 Mod+Slash hotkey-overlay-title="Search keybinds" { spawn "walker" "--height" "980" "--width" "980" "--provider" "menus:keybinds"; }
```

### Credits

Taken from <https://github.com/nickjj/dotfiles>.

local wezterm = require('wezterm')
local act = wezterm.action
local config = wezterm.config_builder and wezterm.config_builder() or {}
config.automatically_reload_config = true
config.window_close_confirmation = 'NeverPrompt'
config.enable_tab_bar = true
config.enable_scroll_bar = true
config.window_background_opacity = 1.0
config.color_scheme = 'Catppuccin Mocha'
config.font_size = 17.0
config.font = wezterm.font('Hack Nerd Font')
config.scrollback_lines = 100000
config.animation_fps = 1
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.inactive_pane_hsb = { saturation = 0.24, brightness = 0.5 }
local bash = { '/opt/homebrew/bin/bash', '--noprofile', '--rcfile', wezterm.home_dir .. '/.config/bash/bashrc', '-i' }
-- Fresh installation: run Bash by default in WezTerm; macOS login shell remains unchanged.
config.default_prog = bash
config.launch_menu = { { label = 'Bash', args = bash } }
config.keys = {
  { key = 'A', mods = 'CMD|SHIFT', action = act.QuickSelect },
  { key = '/', mods = 'CMD', action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },
  { key = '\\', mods = 'CMD', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
  { key = 'h', mods = 'CMD', action = act.ActivatePaneDirection('Left') },
  { key = 'j', mods = 'CMD', action = act.ActivatePaneDirection('Down') },
  { key = 'k', mods = 'CMD', action = act.ActivatePaneDirection('Up') },
  { key = 'g', mods = 'CMD', action = act.ActivatePaneDirection('Right') },
  { key = 'q', mods = 'CMD', action = act.CloseCurrentPane({ confirm = true }) },
  { key = 'LeftArrow', mods = 'CMD', action = act.AdjustPaneSize({ 'Left', 1 }) },
  { key = 'RightArrow', mods = 'CMD', action = act.AdjustPaneSize({ 'Right', 1 }) },
  { key = 'UpArrow', mods = 'CMD', action = act.AdjustPaneSize({ 'Up', 1 }) },
  { key = 'DownArrow', mods = 'CMD', action = act.AdjustPaneSize({ 'Down', 1 }) },
  { key = 'b', mods = 'CMD|SHIFT', action = act.SpawnCommandInNewTab({ args = bash }) },
  { key = 'l', mods = 'CMD|SHIFT', action = act.ShowLauncher },
}
return config

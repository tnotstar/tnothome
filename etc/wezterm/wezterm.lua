local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.default_domain = 'WSL:Archie'
config.default_prog = { 'nu' }

config.initial_cols = 120
config.initial_rows = 28

config.window_background_opacity = 0.9
config.window_decorations = 'TITLE|RESIZE'
config.hide_tab_bar_if_only_one_tab = true

config.font = wezterm.font('JetBrains Mono', { weight = 'Regular' })
config.font_size = 10

config.color_scheme = 'rose-pine'

config.set_environment_variables = {
  MICRO_TRUECOLOR = '1',
  COLORTERM = 'truecolor',
}

config.keys = {
  {
    key = 'h',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'v',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  {
    key = 't',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
}

return config

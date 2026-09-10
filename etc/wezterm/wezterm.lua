local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.default_prog = {
  'wsl.exe',
  '--distribution-id',
  '{8af99870-2861-4628-93f9-ed40832fbc36}',
  '/usr/sbin/bash',
  '--login',
  '-i',
  '-c',
  'exec /usr/sbin/nu --execute \'use utools.nu *; cd ~\'',
}

config.launch_menu = {
  {
    label = 'Nushell (Windows)',
    args = { 'nu.exe' },
    cwd = wezterm.home_dir,
    domain = { DomainName = 'local' },
  },
}

config.initial_cols = 96
config.initial_rows = 44

config.window_decorations = 'TITLE|RESIZE'
config.window_background_opacity = 0.9
config.hide_tab_bar_if_only_one_tab = true

config.font = wezterm.font('JetBrains Mono', { weight = 'Regular' })
config.font_size = 10

config.color_scheme = 'rose-pine'

config.set_environment_variables = {
  MICRO_TRUECOLOR = '1',
  COLORTERM = 'truecolor',
}

config.disable_default_key_bindings = false

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
  
  -- Navegación de paneles estilo Vim (Alt + h/j/k/l)
  { key = 'h', mods = 'ALT', action = wezterm.action.ActivatePaneDirection('Left') },
  { key = 'l', mods = 'ALT', action = wezterm.action.ActivatePaneDirection('Right') },
  { key = 'k', mods = 'ALT', action = wezterm.action.ActivatePaneDirection('Up') },
  { key = 'j', mods = 'ALT', action = wezterm.action.ActivatePaneDirection('Down') },

  -- Redimensión de paneles (Alt + Shift + h/j/k/l)
  { key = 'h', mods = 'ALT|SHIFT', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
  { key = 'l', mods = 'ALT|SHIFT', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },
  { key = 'k', mods = 'ALT|SHIFT', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
  { key = 'j', mods = 'ALT|SHIFT', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },
}

return config

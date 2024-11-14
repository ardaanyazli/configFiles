local wezterm = require("wezterm")

local config = wezterm.config_builder()

config = {
font = wezterm.font('JetBrainsMono Nerd Font Mono'),
automatically_reload_config = true,
enable_tab_bar=false,
window_close_confirmation = 'NeverPrompt',
--window_decorations='RESIZE',
color_scheme='Vs Code Dark+ (Gogh)',
  window_padding={
  left=5,
  right=5
  }
}

return config

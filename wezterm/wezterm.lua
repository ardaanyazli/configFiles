local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Apply your settings to config
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
config.automatically_reload_config = true
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
-- config.window_decorations = "RESIZE"
config.color_scheme = "Vs Code Dark+ (Gogh)"
config.window_padding = {
	left = 5,
	right = 5,
}

-- Set PowerShell Core as the default shell on Windows
if wezterm.target_triple:find("windows") then
	config.default_prog = { "pwsh.exe" }
end

return config

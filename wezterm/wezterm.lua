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
config.max_fps = 240
config.animation_fps = 60

-- Set PowerShell Core as the default shell on Windows
if wezterm.target_triple:find("windows") then
	config.default_prog = { "pwsh.exe" }
end
config.window_background_opacity = 1.0
config.enable_scroll_bar = false

-- Improve resize behavior
config.adjust_window_size_when_changing_font_size = false
config.use_resize_increments = false
config.front_end = "WebGpu"
-- if wezterm.target_triple:find("macos") then
-- 	config.front_end = "OpenGL" -- or "Software" if your GPU has issues
-- end

-- You can also try:
-- enable_wayland = false,  -- if you're on Linux and using Wayland
return config

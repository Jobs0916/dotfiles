-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
-- For example, changing the color scheme:
config.color_scheme = "Tokyo Night"
-- config.font = wezterm.font("JetBrains Mono")
config.font = wezterm.font_with_fallback({
	{ family = "JetBrains Mono", scale = 1.1 },
})
-- Para el control de la transparencia
config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
-- config.linux_window_background_blur = 40 -- No funcion en linux mint
config.scrollback_lines = 3000
config.default_workspace = "home"

-- Tabs config
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.status_update_interval = 1000
config.window_padding = {
	bottom = 0,
	left = 0,
	right = 0,
	top = 0,
}
config.warn_about_missing_glyphs = false

-- and finally, return the configuration to wezterm
return config

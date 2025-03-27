local wezterm = require("wezterm")
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

local config = wezterm.config_builder()
tabline.setup({
	options = {
		icons_enabled = true,
		theme = "Catppuccin Mocha",
		tabs_enabled = true,
		theme_overrides = {},
	},
	sections = {
		tabline_a = { "workspace" },
		tabline_b = {},
		tabline_c = { " " },
		tab_active = {
			"index",
			{ "process", padding = { left = 0, right = 1 } },
			{ "parent", padding = 0 },
			"/",
			{ "cwd", max_length = 32, padding = { left = 0, right = 1 } },
			{ "zoomed", padding = 0 },
			{ "output" },
		},
		tab_inactive = { "index", { "process", padding = { left = 0, right = 1 } }, "output" },
		tabline_x = {},
		tabline_y = {},
		tabline_z = {
			{ "datetime", style = "%Y-%m-%d %H:%M:%S" },
		},
	},
	extensions = {},
})
tabline.apply_to_config(config)

-- Disable Wayland in WezTerm for now, not working in Arch, will mainly be
-- using this in Windows anyway
config.enable_wayland = false

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font({
	family = "JetBrainsMonoNL Nerd Font Mono",
	weight = "Bold",
})

config.font_size = 18.0
-- config.enable_tab_bar = false

config.window_background_opacity = 0.9
config.text_background_opacity = 0.9

config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	-- Turn off the default CMD-m Hide action, allowing CMD-m to
	-- be potentially recognized and handled by the tab
	{
		key = "m",
		mods = "CMD",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = "h",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "v",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- Send "CTRL-B" to the terminal when pressing CTRL-B, CTRL-B
	{
		key = "b",
		mods = "LEADER|CTRL",
		action = wezterm.action.SendKey({ key = "b", mods = "CTRL" }),
	},
}

return config

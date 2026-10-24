return {
	"catppuccin/nvim",
	cond = not vim.g.vscode,
	name = "catppuccin",
	priority = 1000,
	opts = {
		flavour = "mocha",
		transparent_background = false, -- handled by core/transparency.lua for every theme
		term_colors = true,
		integrations = {
			blink_cmp = true,
			dropbar = { enabled = true },
			fidget = true,
			gitsigns = true,
			mini = { enabled = true },
			neotree = true,
			snacks = { enabled = true },
			treesitter = true,
			which_key = true,
		},
	},
}

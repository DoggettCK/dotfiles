return {
	-- Hints keybinds
	"folke/which-key.nvim",
	cond = not vim.g.vscode,
	event = "VeryLazy",
	opts = {
		preset = "helix",
		delay = 500,
		win = {
			border = "rounded",
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show()
			end,
			desc = "All Keymaps (which-key)",
		},
	},
}

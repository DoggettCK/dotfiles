return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
			"lua_ls",
			"rust_analyzer",
			"elixirls",
		},
	},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		-- Useful status updates for LSP.
		{
			"j-hui/fidget.nvim",
			opts = {
				progress = {
					display = {
						done_icon = "✓", -- Icon shown when all LSP progress tasks are complete
					},
				},
				notification = {
					window = {
						winblend = 0, -- Background color opacity in the notification window
					},
				},
			},
		},
	},
}

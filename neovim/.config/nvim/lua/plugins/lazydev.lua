return {
	-- Configures lua_ls for editing the nvim config (vim.* API, plugin types)
	"folke/lazydev.nvim",
	cond = not vim.g.vscode,
	ft = "lua",
	opts = {
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			{ path = "snacks.nvim", words = { "Snacks" } },
		},
	},
}

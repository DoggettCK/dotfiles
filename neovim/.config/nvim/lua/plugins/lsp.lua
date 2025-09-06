return {
	"mason-org/mason-lspconfig.nvim",
	opts = {},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
		{
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			opts = {
				integrations = { ["mason-lspconfig"] = true },
			},
		},
		{
			"j-hui/fidget.nvim",
			opts = {
				-- options
			},
		},
	},
	config = function()
		require("mason").setup()

		require("mason-lspconfig").setup({
			automatic_installation = true,
			ensure_installed = {
				"cssls",
				"eslint",
				"html",
				"jsonls",
				"ts_ls",
				"pyright",
				"tailwindcss",
				"expert",
			},
		})

		require("mason-tool-installer").setup({
			ensure_installed = {
				"prettier",
				"prettierd",
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter
				"pylint",
				"eslint_d",
				"expert",
			},
		})
	end,
}

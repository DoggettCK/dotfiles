return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	opts = {
		servers = {
			lua_ls = {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
					},
				},
			},
			elixir_ls = {},
			eslint = {},
			black = {},
			isort = {},
			stylua = {},
			prettier = {},
			prettierd = {},
		},
	},
	config = function(_, opts)
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls", "eslint" },
		})

		vim.diagnostic.config({
			virtual_text = true,
			underline = true,
		})
		for server, config in pairs(opts.servers) do
			vim.lsp.config(server, config)
			vim.lsp.enable(server)
		end
	end,
}

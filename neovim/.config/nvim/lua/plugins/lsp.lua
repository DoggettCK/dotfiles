return {
	"mason-org/mason-lspconfig.nvim",
	opts = {},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		{
			"neovim/nvim-lspconfig",
			opts = {
				servers = {
					lua_ls = {
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
							},
						},
					},
				},
			},
			config = function(_, opts)
				local lspconfig = require("lspconfig")
				for server, config in pairs(opts.servers) do
					config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
					lspconfig[server].setup(config)
				end
			end,
		},
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

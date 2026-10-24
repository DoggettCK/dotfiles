-- Native LSP (nvim 0.11+). nvim-lspconfig only supplies the default server
-- configs (its lsp/*.lua files); per-server overrides go in this config's
-- lsp/<name>.lua and are merged on top. Capabilities come from blink.cmp,
-- which registers them via vim.lsp.config("*") itself.
return {
	"neovim/nvim-lspconfig",
	cond = not vim.g.vscode,
	lazy = false,
	dependencies = {
		-- mason must set up first so its bin dir is on PATH
		{ "mason-org/mason.nvim", opts = {} },
		{
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			opts = {
				ensure_installed = {
					-- language servers
					"css-lsp",
					"eslint-lsp",
					"html-lsp",
					"json-lsp",
					"lua-language-server",
					"pyright",
					"tailwindcss-language-server",
					"typescript-language-server",
					-- formatters
					"black",
					"isort",
					"prettier",
					"prettierd",
					"stylua",
				},
			},
		},
		{ "j-hui/fidget.nvim", opts = {} },
	},
	config = function()
		vim.diagnostic.config({
			severity_sort = true,
			virtual_text = true,
			float = { border = "rounded" },
		})

		-- rust_analyzer is owned by rustaceanvim; gdscript connects to a running Godot editor
		vim.lsp.enable({
			"cssls",
			"eslint",
			"gdscript",
			"html",
			"jsonls",
			"lua_ls",
			"pyright",
			"tailwindcss",
			"ts_ls",
		})
	end,
}

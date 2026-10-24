local prettier = { "prettierd", "prettier", stop_after_first = true }

return {
	"stevearc/conform.nvim",
	cond = not vim.g.vscode,
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			elixir = { "mix" },
			gdscript = { "gdscript_formatter" },
			-- Conform will run multiple formatters sequentially
			python = { "isort", "black" },
			-- You can customize some of the format options for the filetype (:help conform.format)
			rust = { "rustfmt", lsp_format = "fallback" },
			-- Conform will run the first available formatter
			javascript = prettier,
			javascriptreact = prettier,
			typescript = prettier,
			typescriptreact = prettier,
			css = prettier,
			html = prettier,
			json = prettier,
			markdown = prettier,
			yaml = prettier,
		},
		formatters = {
			-- Same tool as the gd_format zsh alias; reads stdin, writes stdout
			gdscript_formatter = { command = "gdscript-formatter" },
		},
		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 1000,
			lsp_format = "fallback",
		},
	},
}

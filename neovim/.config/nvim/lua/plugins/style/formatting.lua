return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		local format_on_save_options = {
			lsp_fallback = true,
			async = false,
			timeout_ms = 1000,
		}

		conform.setup({
			formatters_by_ft = {
				css = { "prettier" },
				elixir = { "mix" },
				graphql = { "prettier" },
				html = { "prettier" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				json = { "prettier" },
				liquid = { "prettier" },
				lua = { "stylua" },
				markdown = { "prettier" },
				python = { "isort", "black" },
				svelete = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				yaml = { "prettier" },
			},
			format_on_save = format_on_save_options,
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format(format_on_save_options)
		end, { desc = "Format file or range (in visual mode)" })
	end,
}

return {
	-- Sets up rust-analyzer (from rustup) plus :RustLsp runnables/testables/expandMacro
	"mrcjkb/rustaceanvim",
	cond = not vim.g.vscode,
	version = "^9",
	lazy = false, -- the plugin lazy-loads itself on rust files
	init = function()
		vim.g.rustaceanvim = {
			server = {
				on_attach = function(_, bufnr)
					vim.keymap.set("n", "<leader>rt", function()
						vim.cmd.RustLsp("testables")
					end, { buffer = bufnr, desc = "Rust: Testables" })
				end,
			},
		}
	end,
}

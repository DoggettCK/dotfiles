-- Highlight, edit, and navigate code
return {
	"nvim-treesitter/nvim-treesitter",
	version = false,
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		-- NOTE: Ensure you've run `:TSInstall <language>` if you're not getting highlighting
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "elixir", "eex", "heex", "rust", "ruby", "python", "cs", "typescript", "javascript" },
			callback = function()
				vim.treesitter.start()
			end,
		})
	end,
}

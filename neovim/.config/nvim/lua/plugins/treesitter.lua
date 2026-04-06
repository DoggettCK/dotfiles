-- Highlight, edit, and navigate code
return {
	"nvim-treesitter/nvim-treesitter",
	version = false,
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("nvim-treesitter").install({
			"bash",
			"c_sharp",
			"dockerfile",
			"eex",
			"elixir",
			"go",
			"heex",
			"html",
			"http",
			"java",
			"javascript",
			"json",
			"lua",
			"markdown_inline",
			"markdown",
			"python",
			"ruby",
			"rust",
			"typescript",
			"yaml",
		})
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"bash",
				"cs",
				"dockerfile",
				"eex",
				"elixir",
				"go",
				"heex",
				"html",
				"http",
				"java",
				"javascript",
				"json",
				"lua",
				"markdown_inline",
				"markdown",
				"python",
				"ruby",
				"rust",
				"typescript",
				"yaml",
			},
			callback = function()
				vim.treesitter.start()
			end,
		})
	end,
}

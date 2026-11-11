-- Highlight, edit, and navigate code (nvim-treesitter main branch: no lazy-loading)
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install({
			"bash",
			"c",
			"c_sharp",
			"cpp",
			"css",
			"diff",
			"dockerfile",
			"eex",
			"elixir",
			"gdscript",
			"gdshader",
			"go",
			"godot_resource",
			"heex",
			"html",
			"http",
			"java",
			"javascript",
			"json",
			"lua",
			"markdown",
			"markdown_inline",
			"odin",
			"python",
			"query",
			"regex",
			"ruby",
			"rust",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"yaml",
			"zig",
		})
		-- Start treesitter for any filetype with an installed parser
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
			callback = function(args)
				if pcall(vim.treesitter.start, args.buf) then
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}

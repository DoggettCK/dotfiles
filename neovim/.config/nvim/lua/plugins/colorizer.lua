return {
	-- high-performance color highlighter
	-- example: #a6e3a1
	"norcalli/nvim-colorizer.lua",
	cond = not vim.g.vscode,
	config = function()
		require("colorizer").setup()
	end,
}

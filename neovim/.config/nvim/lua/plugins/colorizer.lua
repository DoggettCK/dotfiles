return {
	-- high-performance color highlighter (maintained fork of norcalli's)
	-- example: #a6e3a1
	"NvChad/nvim-colorizer.lua",
	cond = not vim.g.vscode,
	event = { "BufReadPost", "BufNewFile" },
	opts = {},
}

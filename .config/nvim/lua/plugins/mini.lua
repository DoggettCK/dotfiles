return {
	"echasnovski/mini.nvim",
	version = "*",
	config = function()
		require("mini.ai").setup()
		require("mini.operators").setup()
		require("mini.pairs").setup()
		require("mini.bracketed").setup()
		require("mini.comment").setup()
		require("mini.splitjoin").setup()
		require("mini.cursorword").setup()
	end,
}

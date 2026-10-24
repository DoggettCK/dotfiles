return {
	"echasnovski/mini.nvim",
	version = "*",
	config = function()
		require("mini.ai").setup()
			require("mini.pairs").setup()
		require("mini.bracketed").setup()
			require("mini.splitjoin").setup()
		end,
}

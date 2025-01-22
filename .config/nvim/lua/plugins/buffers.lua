return {
	"romgrk/barbar.nvim",
	dependencies = {
		"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
		"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
	},
	opts = {
		noremap = true,
		silent = true,
	},
	config = function()
		require("barbar").setup({
			vim.keymap.set("n", "<leader>bc", "<cmd>BufferClose<CR>", { desc = "[C]lose buffer" }),
			vim.keymap.set("n", "<leader>bd", "<cmd>BufferPickDelete<CR>", { desc = "[D]elete buffer by letter" }),
			vim.keymap.set("n", "<leader>bn", "<cmd>enew<CR>", { desc = "[N]ew buffer" }),
			vim.keymap.set("n", "<leader>bp", "<cmd>BufferPick<CR>", { desc = "[P]ick buffer by letter" }),
		})
	end,
}

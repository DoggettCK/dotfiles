return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	lazy = false,
	---@module "neo-tree"
	---@type neotree.Config?
	opts = {},
	vim.keymap.set("n", "<leader>sb", "<cmd>Neotree buffers toggle=true<CR>", { noremap = true, silent = true }),
	vim.keymap.set("n", "<leader>sf", "<cmd>Neotree toggle=true<CR>", { noremap = true, silent = true }),
	vim.keymap.set("n", "<leader>sg", "<cmd>Neotree git_status toggle=true<CR>", { noremap = true, silent = true }),
}

return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		columns = { "icon", "permissions", "size", "mtime" },
		keymaps = {
			["<C-s>"] = false, -- already bound to file saving
			["<C-h>"] = false, -- want to retain window movement
		},
		watch_for_changes = true,
		view_options = {
			show_hidden = true,
		},
	},
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	config = function()
		require("oil").setup({
			vim.keymap.set("n", "`", "<cmd>Oil --float<CR>", { noremap = true, silent = true }),
		})
	end,
}

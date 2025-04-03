vim.keymap.set("n", "`", "<cmd>Oil --float<CR>", { noremap = true, silent = true })

return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		columns = { "icon", "permissions", "size", "mtime" },
		keymaps = {
			["<C-s>"] = false, -- already bound to file saving
			["<C-h>"] = false, -- want to retain window movement
			["`"] = "<cmd>:wq<CR>", -- inside an Oil window, backtick to close
		},
		watch_for_changes = true,
		view_options = {
			show_hidden = true,
		},
	},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
}

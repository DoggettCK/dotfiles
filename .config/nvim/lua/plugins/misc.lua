-- Standalone plugins with less than 10 lines of config go here
return {
	{
		-- autoclose tags
		"windwp/nvim-ts-autotag",
	},
	{
		-- detect tabstop and shiftwidth automatically
		"tpope/vim-sleuth",
	},
	{
		-- Powerful Git integration for Vim
		"tpope/vim-fugitive",
	},
	{
		-- GitHub integration for vim-fugitive
		"tpope/vim-rhubarb",
	},
	{
		-- Hints keybinds
		"folke/which-key.nvim",
		opts = {
			-- win = {
			--   border = {
			--     { '┌', 'FloatBorder' },
			--     { '─', 'FloatBorder' },
			--     { '┐', 'FloatBorder' },
			--     { '│', 'FloatBorder' },
			--     { '┘', 'FloatBorder' },
			--     { '─', 'FloatBorder' },
			--     { '└', 'FloatBorder' },
			--     { '│', 'FloatBorder' },
			--   },
			-- },
		},
	},
	{
		-- Autoclose parentheses, brackets, quotes, etc.
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		opts = {},
	},
	{
		-- Highlight todo, notes, etc in comments
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
		config = function()
			local todo_comments = require("todo-comments")

			vim.keymap.set("n", "]t", function()
				todo_comments.jump_next()
			end, { desc = "Next TODO comment" })

			vim.keymap.set("n", "[t", function()
				todo_comments.jump_prev()
			end, { desc = "Previous TODO comment" })

			todo_comments.setup()
		end,
	},
	{
		-- high-performance color highlighter
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
		end,
	},
	{
		"rcarriga/nvim-notify",
	},
	{
		"kylechui/nvim-surround",
		event = { "BufReadPre", "BufNewFile" },
		version = "*",
		config = true,
	},
	{
		"vim-test/vim-test",
		dependencies = {
			"preservim/vimux",
		},
		vim.keymap.set("n", "<leader>t", ":TestNearest<CR>"),
		vim.keymap.set("n", "<leader>tf", ":TestFile<CR>"),
		vim.keymap.set("n", "<leader>ta", ":TestSuite<CR>"),
		vim.cmd("let test#strategy = 'vimux'"),
	},
	{
		"rmagatti/auto-session",
		config = function()
			require("auto-session").setup({
				auto_session_suppress_dirs = { "~/", "~/code", "~/Downloads", "/" },
				session_lens = {
					buftypes_to_ignore = {}, -- list of buffer types that should not be deleted from the current session
					load_on_setup = true,
					theme_conf = { border = true },
					previewer = false,
				},
				vim.keymap.set("n", "<leader>ls", require("auto-session.session-lens").search_session, {
					noremap = true,
				}),
			})
		end,
	},
}

return {
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
}

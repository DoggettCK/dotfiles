return {
	"olimorris/persisted.nvim",
	cond = not vim.g.vscode,
	lazy = false,
	config = function()
		require("persisted").setup()
		vim.keymap.set("n", "<leader>ss", function()
			vim.notify("Session Saved")
			vim.cmd(":Persisted save")
		end, { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>sl", function()
			vim.notify("Session Loaded")
			vim.cmd(":Persisted load")
		end, { noremap = true, silent = true })
	end,
}

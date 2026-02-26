return {
	"olimorris/persisted.nvim",
	lazy = false, -- make sure the plugin is always loaded at startup
	config = true,
	vim.keymap.set("n", "<F5>", function()
		vim.notify("Session Saved")
		vim.cmd(":Persisted save")
	end, { noremap = true, silent = true }),
	vim.keymap.set("n", "<F9>", function()
		vim.notify("Session Loaded")
		vim.cmd(":Persisted load")
	end, { noremap = true, silent = true }),
}

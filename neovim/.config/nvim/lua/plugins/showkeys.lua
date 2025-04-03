return {
	"nvzone/showkeys",
	cmd = "ShowkeysToggle",
	maxkeys = 10,
	vim.keymap.set("n", "<leader>k", function()
		vim.notify("Toggling Show Keys")
		vim.cmd("ShowkeysToggle")
	end, { silent = true, noremap = true }),
}

return {
	"nvzone/showkeys",
	cmd = "ShowkeysToggle",
	opts = {
		maxkeys = 10,
		show_count = true,
	},
	vim.keymap.set("n", "<leader>k", function()
		vim.notify("Toggling Show Keys")
		vim.cmd("ShowkeysToggle")
	end, { silent = true, noremap = true }),
}

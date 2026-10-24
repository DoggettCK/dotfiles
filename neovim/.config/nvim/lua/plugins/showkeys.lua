return {
	"nvzone/showkeys",
	cond = not vim.g.vscode,
	cmd = "ShowkeysToggle",
	opts = {
		maxkeys = 10,
		show_count = true,
	},
	keys = {
		{
			"<leader>uk",
			function()
				vim.notify("Toggling Show Keys")
				vim.cmd("ShowkeysToggle")
			end,
			desc = "Toggle Show Keys",
		},
	},
}

return {
	"leath-dub/snipe.nvim",
	keys = {
		{
			"gb",
			function()
				require("snipe").open_buffer_menu()
			end,
			desc = "Open Snipe buffer menu",
		},
	},
	opts = {
		preselect_current = true,
		ui = {
			position = "cursor",
			open_win_override = {
				border = "rounded",
			},
		},
	},
}

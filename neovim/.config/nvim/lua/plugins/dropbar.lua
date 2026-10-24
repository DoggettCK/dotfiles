return {
	-- Breadcrumbs winbar (file > class > function); click or pick segments to jump
	"Bekaboo/dropbar.nvim",
	cond = not vim.g.vscode,
	event = { "BufReadPost", "BufNewFile" },
	opts = {},
	keys = {
		{
			"<leader>;",
			function()
				require("dropbar.api").pick()
			end,
			desc = "Pick breadcrumb",
		},
	},
}

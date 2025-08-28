-- Useful status updates for LSP.
return {
	"j-hui/fidget.nvim",
	opts = {
		progress = {
			display = {
				done_icon = "✓", -- Icon shown when all LSP progress tasks are complete
			},
		},
		notification = {
			window = {
				winblend = 0, -- Background color opacity in the notification window
			},
		},
	},
}

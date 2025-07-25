-- Set lualine as statusline
return {
	"nvim-lualine/lualine.nvim",
	config = function()
		local filename = {
			"filename",
			file_status = true, -- displays file status (readonly status, modified status)
			path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
			symbols = {
				modified = "",
			},
		}

		local hide_in_width = function()
			return vim.fn.winwidth(0) > 100
		end

		require("lualine").setup({
			options = {
				icons_enabled = true,
				-- Some useful glyphs:
				-- https://www.nerdfonts.com/cheat-sheet
				--        
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
				disabled_filetypes = { "alpha", "neo-tree", "Avante" },
				always_divide_middle = true,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", filename },
				lualine_c = {},
				lualine_x = {},
				lualine_y = {
					{ "lsp_status", cond = hide_in_width },
					{ "diagnostics", cond = hide_in_width },
					{ "diff", cond = hide_in_width },
					{ "encoding", cond = hide_in_width },
					{ "filetype", cond = hide_in_width },
				},
				lualine_z = { "location", "progress" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { { "location", padding = 0 } },
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}

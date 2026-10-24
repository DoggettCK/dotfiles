-- Transparent background for any colorscheme. On by default; NVIM_TRANSPARENT=0
-- starts opaque. Toggle live with <leader>ut (see plugins/snacks.lua).
-- lualine handles its own middle section (see plugins/lualine.lua).
local M = {}

vim.g.transparent = os.getenv("NVIM_TRANSPARENT") ~= "0"

-- Pmenu, CursorLine and Visual are left alone so they stay readable
local groups = {
	"Normal",
	"NormalNC",
	"NormalFloat",
	"FloatBorder",
	"FloatTitle",
	"SignColumn",
	"LineNr",
	"FoldColumn",
	"EndOfBuffer",
	"StatusLine",
	"StatusLineNC",
	"WinBar",
	"WinBarNC",
	"NeoTreeNormal",
	"NeoTreeNormalNC",
	"NeoTreeEndOfBuffer",
	"NeoTreeWinSeparator",
	"TroubleNormal",
	"TroubleNormalNC",
	"WhichKeyNormal",
	"FzfLuaNormal",
	"FzfLuaBorder",
	"SnacksNormal",
	"SnacksDashboardNormal",
}

-- Families of groups with one variant per level (Info, Warn, BorderError, ...)
local patterns = {
	"^SnacksNotifier", -- toast body, border/title row, icon
	"^FzfLua.*Title", -- window titles and the title flags badge
}

function M.apply()
	if not vim.g.transparent then
		return
	end
	local names = vim.list_extend({}, groups)
	for name in pairs(vim.api.nvim_get_hl(0, {})) do
		for _, pattern in ipairs(patterns) do
			if name:find(pattern) then
				table.insert(names, name)
			end
		end
	end
	for _, name in ipairs(names) do
		local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
		if not vim.tbl_isempty(hl) then
			hl.bg = nil
			hl.ctermbg = nil
			vim.api.nvim_set_hl(0, name, hl)
		end
	end
end

function M.toggle(state)
	vim.g.transparent = state
	-- Reloading the colorscheme restores the original backgrounds before apply() runs
	vim.cmd.colorscheme(vim.g.colors_name)
end

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("UserTransparency", { clear = true }),
	callback = M.apply,
})

return M

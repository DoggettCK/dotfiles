require("core.options") -- Load general options
require("core.keymaps") -- Load general keymaps
require("core.snippets") -- Custom code snippets

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank({ timeout = 1000 })
	end,
})
-- Install package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Define a table of theme modules
local themes = {
	catppuccin = "plugins.themes.catppuccin",
}

-- Import color theme based on environment variable NVIM_THEME
local default_color_scheme = "catppuccin"
local env_var_nvim_theme = os.getenv("NVIM_THEME") or default_color_scheme

-- Setup plugins
require("lazy").setup({
	require(themes[env_var_nvim_theme]),
	require("plugins.aerial"),
	require("plugins.fzf-lua"),
	require("plugins.blink-cmp"),
	require("plugins.buffers"),
	require("plugins.style.formatting"),
	require("plugins.style.linting"),
	require("plugins.emmet"),
	require("plugins.gitsigns"),
	require("plugins.harpoon"),
	require("plugins.indent-blankline"),
	require("plugins.lualine"),
	require("plugins.lsp.mason"),
	require("plugins.mini"),
	require("plugins.misc"),
	require("plugins.neo-tree"),
	require("plugins.snacks"),
	require("plugins.snipe"),
	require("plugins.telescope"),
	require("plugins.treesitter"),
	require("plugins.trouble"),
	require("plugins.vim-tmux-navigator"),
}, {
	ui = {
		-- If you have a Nerd Font, set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

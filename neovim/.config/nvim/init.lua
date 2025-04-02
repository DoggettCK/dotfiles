require("core.options") -- Load general options
require("core.keymaps") -- Load general keymaps
require("config.lazy") -- Load lazy.nvim
-- require("config.themes") -- Load color themes

-- Highlight when yanking (copying) text
-- see `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 1000 })
	end,
})

-- Setup plugins
-- require("lazy").setup({
-- 	require("plugins.aerial"),
-- 	require("plugins.autocompletion"),
-- 	require("plugins.buffers"),
-- 	require("plugins.conform"),
-- 	require("plugins.emmet"),
-- 	require("plugins.fzf-lua"),
-- 	require("plugins.project"),
-- 	require("plugins.gitsigns"),
-- 	require("plugins.harpoon"),
-- 	require("plugins.indent-blankline"),
-- 	require("plugins.linting"),
-- 	require("plugins.lsp"),
-- 	require("plugins.lualine"),
-- 	require("plugins.mini"),
-- 	require("plugins.misc"),
-- 	require("plugins.neo-tree"),
-- 	require("plugins.none-ls"),
-- 	require("plugins.snacks"),
-- 	require("plugins.snipe"),
-- 	require("plugins.treesitter"),
-- 	require("plugins.trouble"),
-- 	require("plugins.vim-tmux-navigator"),
-- })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

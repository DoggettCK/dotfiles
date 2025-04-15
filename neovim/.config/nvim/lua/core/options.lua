-- Window options
vim.o.termguicolors = true -- set termguicolors to enable highlight groups
vim.o.clipboard = "unnamedplus" -- Sync clipboard between OS and Neovim.
vim.o.title = true
vim.o.mouse = "a" -- Enable mouse mode
vim.o.cmdheight = 1 -- command line invisible unless using it
vim.o.cursorline = true -- highlight the current line
vim.o.showmode = false -- we don't need to see things like -- INSERT -- anymore
vim.o.showtabline = 0 -- always show tabs
vim.o.splitbelow = true -- force all horizontal splits to go below current window
vim.o.splitright = true -- force all vertical splits to go to the right of current window
if vim.fn.has("nvim-0.11") then
	vim.o.winborder = "rounded" -- Unavailable until nvim 0.11
end
vim.o.scrolloff = 4 -- minimal number of screen lines to keep above and below the cursor
vim.o.sidescrolloff = 8 -- minimal number of screen columns either side of cursor if wrap is `false`

-- Git options
vim.wo.signcolumn = "yes" -- Keep signcolumn on by default

-- Line numbers
vim.o.relativenumber = false -- set relative numbered lines off
vim.wo.number = true -- Make line numbers default

-- Case sensitivity
vim.o.ignorecase = true -- Case-insensitive searching UNLESS \C or capital in search
vim.o.smartcase = true -- smart case

-- Indentation
vim.o.autoindent = true -- copy indent from current line when starting new one
vim.o.breakindent = true -- Enable break indent
vim.o.expandtab = true -- convert tabs to spaces
vim.o.numberwidth = 4 -- set number column width to 2 {default 4}
vim.o.shiftwidth = 4 -- the number of spaces inserted for each indentation
vim.o.smartindent = true -- make indenting smarter again
vim.o.smarttab = true -- make indenting smarter again
vim.o.softtabstop = 4 -- Number of spaces that a tab counts for while performing editing operations
vim.o.tabstop = 4 -- insert n spaces for a tab

-- Backup/Undo/swapfile
vim.o.backup = false -- creates a backup file
vim.o.swapfile = false -- creates a swapfile
vim.o.undofile = true -- Save undo history
vim.o.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

-- Wrapping
vim.o.whichwrap = "bs<>[]hl" -- which "horizontal" keys are allowed to travel to prev/next line
vim.o.wrap = false -- display lines as one long line
vim.o.linebreak = true -- companion to wrap don't split words

-- Miscellaneous
vim.o.hlsearch = true -- Set highlight on search
vim.o.updatetime = 250 -- Decrease update time
vim.o.timeoutlen = 300 -- time to wait for a mapped sequence to complete (in milliseconds)
vim.o.completeopt = "menu,menuone,noselect" -- Set completeopt to have a better completion experience
vim.o.backspace = "indent,eol,start" -- allow backspace on
vim.o.pumheight = 10 -- pop up menu height
vim.o.conceallevel = 0 -- so that `` is visible in markdown files
vim.o.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.shortmess:append("c") -- don't give |ins-completion-menu| messages
vim.opt.iskeyword:append("-") -- hyphenated words recognized by searches
vim.opt.formatoptions:remove({ "c", "r", "o" }) -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles") -- separate vim plugins from neovim in case vim still in use

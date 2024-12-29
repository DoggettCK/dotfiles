-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({'n', 'v'}, '<Space>', '<Nop>', {silent = true})

-- For conciseness
local opts = { noremap = true, silent = true }

-- save file
vim.keymap.set('n', '<leader>s', '<cmd> write <CR>', opts)
-- save all open files
vim.keymap.set('n', '<leader>S', '<cmd> writeall <CR>', opts)
-- close file
vim.keymap.set('n', '<leader>w', '<cmd> bdelete <CR>', opts)
-- Force close file without saving
vim.keymap.set('n', '<leader>W', '<cmd> bdelete! <CR>', opts)

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)

-- Window management
vim.keymap.set('n', '<leader>\\', '<C-w>v', opts) -- split window vertically
vim.keymap.set('n', '<leader>-', '<C-w>s', opts) -- split window horizontally

-- Navigate between splits
vim.keymap.set('n', '<C-h>', '<C-W>h', opts)
vim.keymap.set('n', '<C-j>', '<C-W>j', opts)
vim.keymap.set('n', '<C-k>', '<C-W>k', opts)
vim.keymap.set('n', '<C-l>', '<C-W>l', opts)

-- open Neotree with backtick
vim.keymap.set('n', '`', '<cmd> Neotree toggle=true <CR>', opts)

-- Easy escape to normal mode. No english words contain 'jf', and they're
-- typically the keys with raised bumps on them, so typing them without a bit
-- of a delay between them in insert mode will escape out to normal mode.
vim.keymap.set('i', 'jf', '<Esc><Esc>', opts)

-- quit file
vim.keymap.set('n', '<leader>q', '<cmd> q <CR>', opts)

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', opts)

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

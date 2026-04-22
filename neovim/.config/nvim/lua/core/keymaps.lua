-- Keymaps for better default experience

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- For conciseness
local opts = { noremap = true, silent = true }

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Allow moving the cursor through wrapped lines with j, k
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- clear highlights
vim.keymap.set("n", "<Esc>", ":noh<CR>", opts)

-- save file
vim.keymap.set({ "n", "v" }, "<C-s>", "<cmd> w <CR>", opts)
vim.keymap.set("i", "<C-s>", "<Esc><cmd> w <CR>", opts)

-- quit file
vim.keymap.set({ "n", "i" }, "<M-BS>", "<cmd>bd!<CR><ESC>", opts)
vim.keymap.set({ "n" }, "<S-BS>", "<cmd>bd!<CR><ESC>", opts)

-- Vertical scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Find and center
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Move selected or current lines up/down
vim.keymap.set("i", "<A-Down>", "<Esc>:m+<CR>==gi")
vim.keymap.set("i", "<A-Up>", "<Esc>:m-2<CR>==gi")
vim.keymap.set("v", "<A-Up>", ":m-2<CR>gv=gv")
vim.keymap.set("v", "<A-Down>", ":m'>+<CR>gv=gv")
vim.keymap.set("n", "<A-Up>", "ddkP<S-v>")
vim.keymap.set("n", "<A-Down>", "ddp<S-v>")

-- Increment/decrement numbers
vim.keymap.set("n", "<leader>+", "<C-a>", opts)
vim.keymap.set("n", "<leader>-", "<C-x>", opts)

-- Window management (<leader>w*)
vim.keymap.set("n", "<leader>wv", "<C-w>v", opts)
vim.keymap.set("n", "<leader>ws", "<C-w>s", opts)
vim.keymap.set("n", "<leader>we", "<C-w>=", opts)
vim.keymap.set("n", "<leader>wc", ":close<CR>", opts)

-- Navigate between splits
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Keep last yanked when pasting
-- vim.keymap.set("v", "p", '"_dP', opts)

-- Replace word under cursor
vim.keymap.set("n", "<leader>cw", "*``cgn", opts)

-- Explicitly yank to system clipboard (highlighted and entire row)
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Copy filename with or without line to clipboard
vim.keymap.set({ "n", "v" }, "<leader>yf", ":let @+ = expand('%')<CR>", { noremap = true, silent = true })
vim.keymap.set(
	{ "n", "v" },
	"<leader>yl",
	":let @+ = expand('%')..':'..line('.')<CR>",
	{ noremap = true, silent = true }
)

-- Delete every line containing visual selection
vim.keymap.set("v", "<leader>dd", "y :g/<C-r>0/d<CR>", { noremap = true, silent = true })

-- Replace quoted string with contents of paste buffer
vim.keymap.set("n", "<leader>p", 'ci"<C-r>0<Esc>', { noremap = true, silent = true })

-- Diagnostic keymaps (<leader>d*) — overridden by core/vscode.lua in VS Code
if not vim.g.vscode then
	vim.keymap.set("n", "[d", vim.diagnostic.get_prev, { desc = "Go to previous diagnostic message" })
	vim.keymap.set("n", "]d", vim.diagnostic.get_next, { desc = "Go to next diagnostic message" })
	vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
	vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
end

-- Easy escape to normal mode. No english words contain 'jf', and they're
-- typically the keys with raised bumps on them, so typing them without a bit
-- of a delay between them in insert mode will escape out to normal mode.
vim.keymap.set("i", "jf", "<Esc><Esc>", opts)

if not vim.g.vscode then
	vim.keymap.set("n", "<leader>rt", "<cmd>RustTest!<CR>", opts)
end

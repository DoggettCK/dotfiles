-- In Godot's Editor settings, under Text Editor->External:
-- Use External Editor: true
-- Exec Path: nvim
-- Exec Flags: --server ~/.config/godot.pipe --remote-send "<esc>:n {file}<CR>:call cursor({line},{col})<CR>"
--
-- Restart Godot, then open a Godot script in nvim, and it should automatically connect to the LSP server.

local port = tonumber(os.getenv("GDSCRIPT_PORT") or "6005")
local cmd = vim.lsp.rpc.connect("127.0.0.1", port)
local pipe = vim.fn.expand("$HOME/.config/godot.pipe")

vim.lsp.start({
	name = "Godot",
	cmd = cmd,
	root_dir = vim.fs.dirname(vim.fs.find({ "project.godot", ".git" }, { upward = true })[1]),
	on_attach = function(client, bufnr)
		vim.notify("Connecting to Godot LSP: " .. vim.fn.serverstart(pipe))
	end,
})

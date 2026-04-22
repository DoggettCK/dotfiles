-- Replace deprecated vim.tbl_flatten before any plugin loads to suppress the warning
vim.tbl_flatten = function(t)
	return vim.iter(t):flatten(math.huge):totable()
end

require("core.options")
require("core.keymaps")
require("core.autocmd")
if vim.g.vscode then
	require("core.vscode")
end
require("core.lazy")

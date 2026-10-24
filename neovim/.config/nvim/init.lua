require("core.options")
require("core.keymaps")
require("core.autocmd")
if vim.g.vscode then
	require("core.vscode")
else
	require("core.transparency")
end
require("core.lazy")

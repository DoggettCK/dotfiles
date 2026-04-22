-- VS Code specific keymaps (loaded only when running inside vscode-neovim)
-- Requires: https://github.com/vscode-neovim/vscode-neovim
--
-- Extension-dependent mappings (silently no-op if extension not installed):
--   <leader>gg/gl  : LazyGit for VS Code
--   <leader>gb/gf  : GitLens
--   <leader>gB     : GitHub Repositories / GitHub Pull Requests
--   <leader>cR     : File Utils (fileutils.renameFile)
--   <leader>rt     : rust-analyzer

local function vsc(cmd)
	return function()
		vim.fn.VSCodeNotify(cmd)
	end
end

local opts = { noremap = true, silent = true }

-- File/search (replaces fzf-lua)
vim.keymap.set("n", "<leader>ff", vsc("workbench.action.quickOpen"), { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", vsc("workbench.action.findInFiles"), { desc = "Find with Grep" })
vim.keymap.set("n", "<leader>fw", vsc("workbench.action.findInFiles"), { desc = "Find Word" })
vim.keymap.set("n", "<leader>fo", vsc("workbench.action.openRecent"), { desc = "Find Recent Files" })
vim.keymap.set("n", "<leader><leader>", vsc("workbench.action.showAllEditors"), { desc = "Find Buffer" })

-- LSP (replaces nvim-lspconfig + fzf-lua LSP)
vim.keymap.set("n", "gd", vsc("editor.action.revealDefinition"), opts)
vim.keymap.set("n", "K", vsc("editor.action.showHover"), opts)
vim.keymap.set("n", "<leader>lR", vsc("editor.action.rename"), { desc = "Rename Symbol" })
vim.keymap.set({ "n", "v" }, "<leader>la", vsc("editor.action.quickFix"), { desc = "Code Action" })
vim.keymap.set("n", "<leader>lf", vsc("editor.action.formatDocument"), { desc = "Format Buffer" })
vim.keymap.set("n", "<leader>ls", vsc("workbench.action.gotoSymbol"), { desc = "Document Symbols" })
vim.keymap.set("n", "<leader>lS", vsc("workbench.action.showAllSymbols"), { desc = "Workspace Symbols" })
vim.keymap.set("n", "<leader>lt", vsc("editor.action.goToTypeDefinition"), { desc = "Go to Type" })
vim.keymap.set("n", "<leader>lr", vsc("editor.action.goToReferences"), { desc = "Go to References" })
vim.keymap.set("n", "<leader>li", vsc("editor.action.goToImplementation"), { desc = "Go to Implementation" })

-- Diagnostics (replaces vim.diagnostic.*)
vim.keymap.set("n", "[d", vsc("editor.action.marker.prevInFiles"), opts)
vim.keymap.set("n", "]d", vsc("editor.action.marker.nextInFiles"), opts)
vim.keymap.set("n", "<leader>df", vsc("editor.action.showHover"), { desc = "Show Hover/Diagnostic" })
vim.keymap.set("n", "<leader>dl", vsc("workbench.actions.view.problems"), { desc = "Problems Panel" })

-- Problems panel (replaces trouble.nvim)
vim.keymap.set("n", "<leader>td", vsc("workbench.actions.view.problems"), { desc = "Toggle Problems" })
vim.keymap.set("n", "<leader>tD", vsc("workbench.actions.view.problems"), { desc = "Buffer Problems" })
vim.keymap.set("n", "<leader>ts", vsc("workbench.action.gotoSymbol"), { desc = "Symbols" })
vim.keymap.set("n", "<leader>tl", vsc("editor.action.goToReferences"), { desc = "References" })

-- File tree / source control (replaces neo-tree)
vim.keymap.set("n", "`", vsc("workbench.view.explorer"), opts)
vim.keymap.set("n", "<leader>ng", vsc("workbench.view.scm"), { desc = "Source Control View" })
vim.keymap.set("n", "<leader>nb", vsc("workbench.action.showAllEditors"), { desc = "Open Editors" })

-- Window management (replaces split commands)
vim.keymap.set("n", "<leader>wv", vsc("workbench.action.splitEditor"), { desc = "Split Vertical" })
vim.keymap.set("n", "<leader>ws", vsc("workbench.action.splitEditorDown"), { desc = "Split Horizontal" })
vim.keymap.set("n", "<leader>wc", vsc("workbench.action.closeActiveEditor"), { desc = "Close Editor" })
vim.keymap.set("n", "<C-h>", vsc("workbench.action.focusLeftGroup"), opts)
vim.keymap.set("n", "<C-j>", vsc("workbench.action.focusBelowGroup"), opts)
vim.keymap.set("n", "<C-k>", vsc("workbench.action.focusAboveGroup"), opts)
vim.keymap.set("n", "<C-l>", vsc("workbench.action.focusRightGroup"), opts)

-- Editor/buffer close (replaces :bd!)
vim.keymap.set({ "n", "i" }, "<M-BS>", vsc("workbench.action.closeActiveEditor"), opts)
vim.keymap.set("n", "<S-BS>", vsc("workbench.action.closeActiveEditor"), opts)

-- Git (replaces snacks lazygit + fugitive)
vim.keymap.set("n", "<leader>gg", vsc("lazygit.openLazygit"), { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gl", vsc("lazygit.openLazygit"), { desc = "Lazygit Log" })
vim.keymap.set("n", "<leader>gf", vsc("gitlens.showFileHistoryView"), { desc = "File History" })
vim.keymap.set("n", "<leader>gb", vsc("gitlens.toggleLineBlame"), { desc = "Git Blame Line" })
vim.keymap.set({ "n", "v" }, "<leader>gB", vsc("github.openFileOnRemote"), { desc = "Git Browse" })

-- Zen mode (replaces snacks.zen)
vim.keymap.set("n", "<leader>z", vsc("workbench.action.toggleZenMode"), { desc = "Toggle Zen Mode" })
vim.keymap.set("n", "<leader>Z", vsc("workbench.action.toggleZenMode"), { desc = "Toggle Zoom" })

-- File rename (replaces snacks.rename — requires File Utils extension)
vim.keymap.set("n", "<leader>cR", vsc("fileutils.renameFile"), { desc = "Rename File" })

-- Harpoon-like quick tab access (replaces harpoon)
vim.keymap.set("n", "<leader>1", vsc("workbench.action.openEditorAtIndex1"), opts)
vim.keymap.set("n", "<leader>2", vsc("workbench.action.openEditorAtIndex2"), opts)
vim.keymap.set("n", "<leader>3", vsc("workbench.action.openEditorAtIndex3"), opts)
vim.keymap.set("n", "<leader>4", vsc("workbench.action.openEditorAtIndex4"), opts)
vim.keymap.set("n", "<leader>M", vsc("workbench.action.showAllEditors"), { desc = "Show All Editors" })
vim.keymap.set("n", "<leader>ma", vsc("workbench.action.pinEditor"), { desc = "Pin Editor" })

-- Toggles (replaces snacks.toggle)
vim.keymap.set("n", "<leader>us", vsc("editor.action.toggleSpellCheck"), { desc = "Toggle Spell" })
vim.keymap.set("n", "<leader>uw", vsc("editor.action.toggleWordWrap"), { desc = "Toggle Wrap" })
vim.keymap.set("n", "<leader>uh", vsc("editor.action.inlayHints.toggle"), { desc = "Toggle Inlay Hints" })

-- Notification history → VS Code output panel
vim.keymap.set("n", "<leader>nh", vsc("workbench.action.showOutputChannels"), { desc = "Output Channels" })

-- Rust test (replaces RustTest! — requires rust-analyzer extension)
vim.keymap.set("n", "<leader>rt", vsc("rust-analyzer.runSingle"), { desc = "Run Rust Test" })

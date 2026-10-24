vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

if not vim.g.vscode then
	-- Built-in defaults also apply: grn, gra, grr, gri, grt, gO, K, [d, ]d, <C-s> (insert)
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLSPConfig", {}),
		callback = function(ev)
			local map = function(keys, func, desc, mode)
				vim.keymap.set(mode or "n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
			end

			local fzf = require("fzf-lua")
			map("gd", fzf.lsp_definitions, "Goto Definition")
			map("<leader>ls", fzf.lsp_document_symbols, "Doc Symbols")
			map("<leader>lS", fzf.lsp_live_workspace_symbols, "Dynamic Symbols")
			map("<leader>lt", fzf.lsp_typedefs, "Goto Type")
			map("<leader>lr", fzf.lsp_references, "Goto References")
			map("<leader>li", fzf.lsp_implementations, "Goto Impl")

			map("<leader>lR", vim.lsp.buf.rename, "Rename")
			map("<leader>la", vim.lsp.buf.code_action, "Code Action", { "n", "v" })
			map("<leader>lf", function()
				require("conform").format({ lsp_format = "fallback" })
			end, "Format")
		end,
	})
end

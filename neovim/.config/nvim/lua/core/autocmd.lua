vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

if not vim.g.vscode then
	vim.api.nvim_create_autocmd("LSPAttach", {
		group = vim.api.nvim_create_augroup("UserLSPConfig", {}),
		callback = function(ev)
			local map = function(keys, func, desc)
				vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
			end

			local fzf = require("fzf-lua")
			map("gd", fzf.lsp_definitions, "Goto Definition")
			map("<leader>ls", fzf.lsp_document_symbols, "Doc Symbols")
			map("<leader>lS", fzf.lsp_live_workspace_symbols, "Dynamic Symbols")
			map("<leader>lt", fzf.lsp_typedefs, "Goto Type")
			map("<leader>lr", fzf.lsp_references, "Goto References")
			map("<leader>li", fzf.lsp_implementations, "Goto Impl")

			map("K", vim.lsp.buf.hover, "hover")
			map("<leader>lR", vim.lsp.buf.rename, "Rename")
			map("<leader>la", vim.lsp.buf.code_action, "Code Action")
			map("<leader>lf", vim.lsp.buf.format, "Format")

			vim.keymap.set("v", "<leader>la", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "LSP: code_action" })

			-- local dap = require("dap")
			-- map("<leader>dt", dap.toggle_breakpoint, "Toggle Break")
			-- map("<leader>dc", dap.continue, "Continue")
			-- map("<leader>dr", dap.repl.open, "Inspect")
			-- map("<leader>dk", dap.terminate, "Kill")
			--
			-- map("<leader>dso", dap.step_over, "Step Over")
			-- map("<leader>dsi", dap.step_into, "Step Into")
			-- map("<leader>dsu", dap.step_out, "Step Out")
			-- map("<leader>dl", dap.run_last, "Run Last")
			--
			-- local dapui = require("dapui")
			-- map("<leader>duu", dapui.open, "open ui")
			-- map("<leader>duc", dapui.close, "open ui")
		end,
	})
end

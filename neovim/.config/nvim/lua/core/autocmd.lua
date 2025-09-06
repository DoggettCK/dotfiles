vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("LSPAttach", {
	group = vim.api.nvim_create_augroup("UserLSPConfig", {}),
	callback = function(ev)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
		end

		local fzf = require("fzf-lua")
		map("gd", fzf.lsp_definitions, "Goto Definition")
		map("<leader>fs", fzf.lsp_document_symbols, "Doc Symbols")
		map("<leader>fS", fzf.lsp_live_workspace_symbols, "Dynamic Symbols")
		map("<leader>ft", fzf.lsp_typedefs, "Goto Type")
		map("<leader>fr", fzf.lsp_references, "Goto References")
		map("<leader>fi", fzf.lsp_implementations, "Goto Impl")

		map("K", vim.lsp.buf.hover, "hover")
		map("<leader>E", vim.diagnostic.open_float, "diagnostic")
		map("<leader>rn", vim.lsp.buf.rename, "rename")
		map("<leader>ca", vim.lsp.buf.code_action, "code action")
		map("<leader>wf", vim.lsp.buf.format, "format")

		vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "LSP: code_action" })

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

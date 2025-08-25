vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end
		-- defaults:
		-- https://neovim.io/doc/user/news-0.11.html#_defaults

		map("gl", vim.diagnostic.open_float, "Open Diagnostic Float")
		map("K", vim.lsp.buf.hover, "Hover Documentation")
		map("gs", vim.lsp.buf.signature_help, "Signature Documentation")
		map("<leader>la", vim.lsp.buf.code_action, "Code Action")
		map("<leader>lr", vim.lsp.buf.rename, "Rename all references")
		map("<leader>lf", vim.lsp.buf.format, "Format")
		map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")
		-- jump to the definition of the word under your cursor.
		--  this is where a variable was first declared, or where a function is defined, etc.
		--  to jump back, press <c-t>.
		map("gd", require("fzf-lua").lsp_definitions, "[g]oto [d]efinition")

		-- find references for the word under your cursor.
		map("gr", require("fzf-lua").lsp_references, "[g]oto [r]eferences")

		-- jump to the implementation of the word under your cursor.
		--  useful when your language has ways of declaring types without an actual implementation.
		map("gi", require("fzf-lua").lsp_implementations, "[g]oto [i]mplementation")

		-- jump to the type of the word under your cursor.
		--  useful when you're not sure what type a variable is and you want to see
		--  the definition of its *type*, not where it was *defined*.
		map("<leader>d", require("fzf-lua").lsp_typedefs, "Type [d]efinition")

		-- fuzzy find all the symbols in your current document.
		--  symbols are things like variables, functions, types, etc.
		map("<leader>ds", require("fzf-lua").lsp_document_symbols, "[d]ocument [s]ymbols")

		-- fuzzy find all the symbols in your current workspace.
		--  similar to document symbols, except searches over your entire project.
		map("<leader>ws", require("fzf-lua").lsp_live_workspace_symbols, "[w]orkspace [s]ymbols")

		-- rename the variable under your cursor.
		--  most language servers support renaming across files, etc.
		map("<leader>cr", vim.lsp.buf.rename, "[C]ode Action: [R]ename")

		-- execute a code action, usually your cursor needs to be on top of an error
		-- or a suggestion from your lsp for this to activate.
		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

		-- warn: this is not goto definition, this is goto declaration.
		--  for example, in c this would take you to the header.
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		local function client_supports_method(client, method, bufnr)
			if vim.fn.has("nvim-0.11") == 1 then
				return client:supports_method(method, bufnr)
			else
				return client.supports_method(method, { bufnr = bufnr })
			end
		end

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if
			client
			and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
		then
			local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

			-- When cursor stops moving: Highlights all instances of the symbol under the cursor
			-- When cursor moves: Clears the highlighting
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			-- When LSP detaches: Clears the highlighting
			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
				end,
			})
		end
	end,
})

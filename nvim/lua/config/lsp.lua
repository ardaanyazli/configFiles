local lspCaps = vim.lsp.protocol.make_client_capabilities()
lspCaps.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}
-- Enable all language servers
local servers = {
	"lua_ls",
	-- "gopls",
	-- "pyright",
	-- "rust_analyzer",
	-- "ts_ls",
	-- "html",
	-- "cssls",
	-- "marksman",
	-- "terraformls",
	-- "roslyn_ls", --will check with native lsp
	"roslyn",
}

for _, server in ipairs(servers) do
	vim.lsp.enable(server, { capabilities = lspCaps })
end
vim.lsp.inlay_hint.enable();
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
vim.opt.foldlevel = 99 -- Open all folds by default
vim.opt.foldenable = true
-- LSP Attach function for keybindings
local function on_attach(ev)
	local bufnr = ev.buf
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	local opts = { buffer = bufnr, silent = true }
	local fzflua = require("fzf-lua")

	-- fzf-lua LSP bindings
	vim.keymap.set("n", "gd", fzflua.lsp_definitions, opts)
	vim.keymap.set("n", "gr", fzflua.lsp_references, opts)
	vim.keymap.set("n", "gI", fzflua.lsp_implementations, opts)
	vim.keymap.set("n", "<leader>D", fzflua.lsp_typedefs, opts)
	vim.keymap.set("n", "<leader>ds", fzflua.lsp_document_symbols, opts)
	vim.keymap.set("n", "<leader>ws", fzflua.lsp_workspace_symbols, opts)

	-- Built-in LSP functions
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

	-- Format (prefer conform.nvim)
	vim.keymap.set("n", "<leader>f", function()
		local ok, conform = pcall(require, "conform")
		if ok then
			conform.format({ async = true, lsp_fallback = true })
		else
			vim.lsp.buf.format({ async = true })
		end
	end, opts)

	-- Diagnostics
	vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

	-- Inlay hints toggle
	-- if vim.lsp.buf.inlay_hint then
	-- 	vim.keymap.set("n", "<leader>th", function()
	-- 		vim.lsp.buf.inlay_hint(bufnr, nil)
	-- 	end, opts)
	-- end

	-- Set omnifunc for completion
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

	-- CodeLens auto-refresh
	if client and client.server_capabilities.codeLensProvider then
		local group = vim.api.nvim_create_augroup("LspCodeLensRefresh_" .. bufnr, { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
			group = group,
			buffer = bufnr,
			callback = vim.lsp.codelens.refresh,
		})
		vim.lsp.codelens.refresh()
	end
end
-- Configure diagnostics display
vim.diagnostic.config({
	virtual_text = false,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅙", -- nf-md-close_circle
			[vim.diagnostic.severity.WARN] = "", -- nf-md-alert_circle
			[vim.diagnostic.severity.INFO] = "󰋼", -- nf-md-information
			[vim.diagnostic.severity.HINT] = "", -- nf-md-lightbulb_on_outline
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		-- border = "rounded", -- or "single", "double", "shadow", "solid", etc.
		source = "always", -- always show the source in the popup
		header = "",
		prefix = "",
	},
})

-- Create LspAttach autocommand
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = on_attach,
})

-- Enable completion triggered by <c-x><c-o>
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Optional: Add custom LSP commands
vim.lsp.commands["PyrightOrganizeImports"] = function(command, ctx)
	local params = {
		command = "pyright.organizeimports",
		arguments = { vim.uri_from_bufnr(ctx.bufnr) },
	}
	vim.lsp.buf_request(ctx.bufnr, "workspace/executeCommand", params)
end

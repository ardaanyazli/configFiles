-- Enable all language servers
local servers = {
	"lua_ls",
	"gopls",
	"pyright",
	"rust_analyzer",
	"ts_ls",
	"html",
	"cssls",
	"marksman",
	"terraformls",
	--"omnisharp",
	"roslyn",
}

for _, server in ipairs(servers) do
	vim.lsp.enable(server)
end
-- LSP Attach function for keybindings
local function on_attach(ev)
	local opts = { buffer = ev.buf, silent = true }
	local fzflua = require("fzf-lua")

	-- fzf-lua LSP bindings
	vim.keymap.set("n", "gd", function()
		fzflua.lsp_definitions()
	end, opts)
	vim.keymap.set("n", "gr", function()
		fzflua.lsp_references()
	end, opts)
	vim.keymap.set("n", "gI", function()
		fzflua.lsp_implementations()
	end, opts)
	vim.keymap.set("n", "<leader>D", function()
		fzflua.lsp_typedefs()
	end, opts)
	vim.keymap.set("n", "<leader>ds", function()
		fzflua.lsp_document_symbols()
	end, opts)
	vim.keymap.set("n", "<leader>ws", function()
		fzflua.lsp_workspace_symbols()
	end, opts)

	-- Built-in LSP functions (unchanged)
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

	-- Format with conform.nvim if available, fallback to LSP
	vim.keymap.set("n", "<leader>f", function()
		local conform_ok, conform = pcall(require, "conform")
		if conform_ok then
			conform.format({ async = true, lsp_fallback = true })
		else
			vim.lsp.buf.format({ async = true })
		end
	end, opts)

	-- Diagnostics
	vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

	-- Inlay hints toggle (if supported)
	if vim.lsp.buf.inlay_hint then
		vim.keymap.set("n", "<leader>th", function()
			vim.lsp.buf.inlay_hint(0, nil)
		end, opts)
	end

	-- Set omnifunc for completion
	vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
end
-- LSP Attach function for keybindings
-- local function on_attach(ev)
-- 	local opts = { buffer = ev.buf, silent = true }
--
-- 	-- Telescope LSP bindings (assumes telescope is available)
-- 	vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
-- 	vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
-- 	vim.keymap.set("n", "gI", "<cmd>Telescope lsp_implementations<CR>", opts)
-- 	vim.keymap.set("n", "<leader>D", "<cmd>Telescope lsp_type_definitions<CR>", opts)
-- 	vim.keymap.set("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<CR>", opts)
-- 	vim.keymap.set("n", "<leader>ws", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", opts)
--
-- 	-- Built-in LSP functions
-- 	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
-- 	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
-- 	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
-- 	vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
-- 	vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
-- 	vim.keymap.set("n", "<leader>wl", function()
-- 		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- 	end, opts)
-- 	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
-- 	vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
--
-- 	-- Format with conform.nvim if available, fallback to LSP
-- 	vim.keymap.set("n", "<leader>f", function()
-- 		local conform_ok, conform = pcall(require, "conform")
-- 		if conform_ok then
-- 			conform.format({ async = true, lsp_fallback = true })
-- 		else
-- 			vim.lsp.buf.format({ async = true })
-- 		end
-- 	end, opts)
--
-- 	-- Diagnostics
-- 	vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
-- 	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
-- 	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
-- 	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
--
-- 	-- Inlay hints toggle (if supported)
-- 	if vim.lsp.buf.inlay_hint then
-- 		vim.keymap.set("n", "<leader>th", function()
-- 			vim.lsp.buf.inlay_hint(0, nil)
-- 		end, opts)
-- 	end
--
-- 	-- Set omnifunc for completion
-- 	vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
-- end

-- Configure diagnostics display
vim.diagnostic.config({
	virtual_text = false,
	signs = {
		[vim.diagnostic.severity.ERROR] = "󰅙", -- nf-md-close_circle
		[vim.diagnostic.severity.WARN] = "", -- nf-md-alert_circle
		[vim.diagnostic.severity.INFO] = "󰋼", -- nf-md-information
		[vim.diagnostic.severity.HINT] = "", -- nf-md-lightbulb_on_outline
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

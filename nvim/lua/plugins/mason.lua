-- Mason integration for automatic server management
vim.api.nvim_create_user_command("MasonInstallAll", function()
	vim.cmd("MasonInstall " .. table.concat({
		"gopls",
		"pyright",
		"rust-analyzer",
		"typescript-language-server",
		"vscode-html-language-server",
		"vscode-css-language-server",
		"marksman",
		"terraform-ls",
		"roslyn", -- Changed from omnisharp
	}, " "))
	print("LSP configuration loaded for Neovim 0.11.3")
end, {})

return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		-- enable mason and configure icons
		mason.setup({
			max_concurrent_installers = 10,
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
			registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
			},
			ensure_installed = {
				"gopls", -- Go
				"pyright", -- Python
				"rust_analyzer", -- Rust
				"ts_ls", -- TypeScript/JavaScript
				"html", -- HTML
				"cssls", -- CSS
				"marksman", -- Markdown
				"terraformls", -- Terraform
				"roslyn", -- C# (changed from omnisharp)
				"stylua",
				"prettierd",
				"eslint_d",
				"terraform",
				"htmlhint",
				"markdownlint",
			},
			automatic_installation = true,
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"gopls", -- Go
				"pyright", -- Python
				"rust_analyzer", -- Rust
				"ts_ls", -- TypeScript/JavaScript
				"html", -- HTML
				"cssls", -- CSS
				"marksman", -- Markdown
				"terraformls", -- Terraform
				"roslyn", -- C# (changed from omnisharp)
			},
			automatic_installation = true,
		})
	end,
}

return {
	"williamboman/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
			"lua_ls",
			"gopls",
			"pyright",
			"rust_analyzer",
			"ts_ls",
			"html",
			"cssls",
			"marksman",
			"terraformls",
			-- "roslyn",
		},
		automatic_installation = true,
	},
}

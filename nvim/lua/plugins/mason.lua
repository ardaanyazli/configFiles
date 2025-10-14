return {
	"williamboman/mason.nvim",
	opts = {
		max_concurrent_installers = 10,
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
			border = "rounded",
		},
	},
}

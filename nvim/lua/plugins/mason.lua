return {
	"williamboman/mason.nvim",
	opts = {
		registries = {
			"github:mason-org/mason-registry",
			"github:Crashdummyy/mason-registry",
		},
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

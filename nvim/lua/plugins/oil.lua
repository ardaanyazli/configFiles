return {
	"stevearc/oil.nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	opts = {},
	keys = {
		{ "~", "<cmd>Oil --float<CR>", desc = "Open Oil in float" },
	},
}

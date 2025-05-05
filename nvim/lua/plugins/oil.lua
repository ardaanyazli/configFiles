return {
	"stevearc/oil.nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	opts = {
		keymaps = {
			["q"] = "actions.close", -- bind 'q' to close
			["<C-c>"] = false, -- unbind Ctrl-c
		}
	},
	keys = {
		{ "~", "<cmd>Oil --float<CR>", mode = 'n', desc = "Open Oil in float" },
	},
}

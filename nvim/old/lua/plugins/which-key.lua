return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.opt.timeout = true
		vim.opt.timeoutlen = 500
	end,
	opts = {
		border = "rounded", -- or "single", "double", "solid", "shadow"
		position = "bottom", -- "bottom" or "right"
		winblend = 10, -- transparency
		max_width = 60, -- limit width
		max_height = 0.4, -- percent of screen height
	}
}

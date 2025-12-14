return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = function()
		local lazy_status = require("lazy.status") -- Load lazy.status

		return {
			theme = "tokyonight",
			sections = {
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ffbe64" }, -- Corrected hex color code
					},
				},
			},
		}
	end,
}

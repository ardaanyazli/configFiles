return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	opts = {
		view = {
			width = 35,
			relativenumber = false,
		},
		renderer = {
			indent_markers = {
				enable = true,
			},
			icons = {
				glyphs = {
					folder = {
						arrow_closed = "",
						arrow_open = "",
					},
				},
			},
		},
		actions = {
			open_file = {
				window_picker = {
					enable = true,
				},
			},
		},
		filters = {
			custom = { ".DS_Store" },
		},
		git = {
			ignore = false,
		},
	},
	keys = {
		{ "<leader>ee", "<cmd>NvimTreeToggle<CR>",         desc = "Toggle file explorer" },
		{ "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", desc = "oggle file explorer on current file" },
		{ "<leader>ec", "<cmd>NvimTreeCollapse<CR>",       desc = "Collapse file explorer" },
		{ "<leader>er", "<cmd>NvimTreeRefresh<CR>",        desc = "Refresh file explorer" }
	}
}

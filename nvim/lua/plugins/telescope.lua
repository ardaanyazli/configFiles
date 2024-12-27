return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = function()
				local is_windows = vim.loop.os_uname().sysname:lower():find("windows")
				if is_windows then
					vim.fn.system(
						"cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release ; cmake --build build --config Release ; cp ./build/Release/libfzf.dll ./build/libfzf.dll"
					)
				else
					vim.fn.system("make")
				end
			end,
		},
		"folke/todo-comments.nvim",
	},
	config = function()
		local opts = {
			defaults = { path_display = { "smart" } },
			pickers = {
				find_files = {
					theme = "ivy", -- Set the 'ivy' theme for the 'find_files' picker
				},
				buffers = {
					theme = "dropdown", -- Set the 'dropdown' theme for the 'buffers' picker
				},
			},
		}
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")
		telescope.setup(opts)
		telescope.load_extension("fzf")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
		vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find todos" })
	end,
}

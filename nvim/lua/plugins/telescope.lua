return {
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = function()
			local fzf_lib = vim.fn.stdpath("data") .. "/lazy/telescope-fzf-native.nvim/build/libfzf.so"
			if vim.fn.has("win32") == 1 then
				fzf_lib = vim.fn.stdpath("data") .. "/lazy/telescope-fzf-native.nvim/build/Release/fzf.dll"
			end

			if vim.fn.filereadable(fzf_lib) == 1 then
				print("[Telescope FZF] Native binary already built.")
				return
			end

			local ok
			if vim.fn.has("win32") == 1 then
				ok = vim.fn.system({
					"cmake",
					"-S.",
					"-Bbuild",
					"-DCMAKE_BUILD_TYPE=Release",
					"&&",
					"cmake",
					"--build",
					"build",
					"--config",
					"Release",
					"&&",
					"cmake",
					"--install",
					"build",
					"--prefix",
					"build"
				})
			else
				ok = vim.fn.system("make")
			end

			if vim.v.shell_error ~= 0 then
				error("Failed to build telescope-fzf-native.nvim:\n" .. ok)
			end
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")
			telescope.setup({})
			telescope.load_extension("fzf")

			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
		end,
	},
}

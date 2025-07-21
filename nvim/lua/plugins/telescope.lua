return {
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		-- Alternative build command for systems without make
		-- build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
		cond = function()
			return vim.fn.executable("make") == 1
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		cmd = "Telescope",
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
			{ "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{ "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
			{ "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in Buffer" },
			{ "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Find Word Under Cursor" },
			{ "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
			{ "<leader>fq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
			{ "<leader>fl", "<cmd>Telescope loclist<cr>", desc = "Location List" },
			{ "<leader>fj", "<cmd>Telescope jumplist<cr>", desc = "Jump List" },
			{ "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Marks" },
			{ "<leader>ft", "<cmd>Telescope treesitter<cr>", desc = "Treesitter Symbols" },
			{ "<leader>fv", "<cmd>Telescope vim_options<cr>", desc = "Vim Options" },
			{ "<leader>fp", "<cmd>Telescope resume<cr>", desc = "Resume Previous Search" },

			-- Git related
			{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
			{ "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },
			{ "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
			{ "<leader>gf", "<cmd>Telescope git_files<cr>", desc = "Git Files" },

			-- LSP related
			{ "<leader>lr", "<cmd>Telescope lsp_references<cr>", desc = "LSP References" },
			{ "<leader>ld", "<cmd>Telescope lsp_definitions<cr>", desc = "LSP Definitions" },
			{ "<leader>li", "<cmd>Telescope lsp_implementations<cr>", desc = "LSP Implementations" },
			{ "<leader>lt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "LSP Type Definitions" },
			{ "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
			{ "<leader>lw", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
			{ "<leader>lc", "<cmd>Telescope lsp_incoming_calls<cr>", desc = "Incoming Calls" },
			{ "<leader>lo", "<cmd>Telescope lsp_outgoing_calls<cr>", desc = "Outgoing Calls" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local builtins = require("telescope.builtin")
			telescope.load_extension("fzf")
		end,
	},
}

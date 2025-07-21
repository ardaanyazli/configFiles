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
			{ "<leader>ff", "<cmd>Telescope find_files<cr>",                desc = "Find Files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>",                 desc = "Live Grep" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>",                   desc = "Buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>",                 desc = "Help Tags" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>",                  desc = "Recent Files" },
			{ "<leader>fc", "<cmd>Telescope commands<cr>",                  desc = "Commands" },
			{ "<leader>fk", "<cmd>Telescope keymaps<cr>",                   desc = "Keymaps" },
			{ "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in Buffer" },
			{ "<leader>fw", "<cmd>Telescope grep_string<cr>",               desc = "Find Word Under Cursor" },
			{ "<leader>fd", "<cmd>Telescope diagnostics<cr>",               desc = "Diagnostics" },
			{ "<leader>fq", "<cmd>Telescope quickfix<cr>",                  desc = "Quickfix List" },
			{ "<leader>fl", "<cmd>Telescope loclist<cr>",                   desc = "Location List" },
			{ "<leader>fj", "<cmd>Telescope jumplist<cr>",                  desc = "Jump List" },
			{ "<leader>fm", "<cmd>Telescope marks<cr>",                     desc = "Marks" },
			{ "<leader>ft", "<cmd>Telescope treesitter<cr>",                desc = "Treesitter Symbols" },
			{ "<leader>fv", "<cmd>Telescope vim_options<cr>",               desc = "Vim Options" },
			{ "<leader>fp", "<cmd>Telescope resume<cr>",                    desc = "Resume Previous Search" },

			-- Git related
			{ "<leader>gc", "<cmd>Telescope git_commits<cr>",               desc = "Git Commits" },
			{ "<leader>gb", "<cmd>Telescope git_branches<cr>",              desc = "Git Branches" },
			{ "<leader>gs", "<cmd>Telescope git_status<cr>",                desc = "Git Status" },
			{ "<leader>gf", "<cmd>Telescope git_files<cr>",                 desc = "Git Files" },

			-- LSP related
			{ "<leader>lr", "<cmd>Telescope lsp_references<cr>",            desc = "LSP References" },
			{ "<leader>ld", "<cmd>Telescope lsp_definitions<cr>",           desc = "LSP Definitions" },
			{ "<leader>li", "<cmd>Telescope lsp_implementations<cr>",       desc = "LSP Implementations" },
			{ "<leader>lt", "<cmd>Telescope lsp_type_definitions<cr>",      desc = "LSP Type Definitions" },
			{ "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>",      desc = "Document Symbols" },
			{ "<leader>lw", "<cmd>Telescope lsp_workspace_symbols<cr>",     desc = "Workspace Symbols" },
			{ "<leader>lc", "<cmd>Telescope lsp_incoming_calls<cr>",        desc = "Incoming Calls" },
			{ "<leader>lo", "<cmd>Telescope lsp_outgoing_calls<cr>",        desc = "Outgoing Calls" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local trouble = pcall(require, "trouble")

			-- Custom function to open files in trouble if available
			local open_with_trouble = function(...)
				if trouble then
					return require("trouble.sources.telescope").open(...)
				else
					return actions.select_default(...)
				end
			end

			telescope.setup({
				defaults = {
					-- Visual configuration
					prompt_prefix = "   ",
					selection_caret = " ",
					entry_prefix = "  ",
					multi_icon = " ",

					-- Sorting and filtering
					sorting_strategy = "ascending",
					selection_strategy = "reset",
					scroll_strategy = "cycle",

					-- Layout configuration
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.55,
							results_width = 0.8,
						},
						vertical = {
							mirror = false,
						},
						width = 0.87,
						height = 0.80,
						preview_cutoff = 120,
					},

					-- File and directory handling
					file_ignore_patterns = {
						"^.git/",
						"^.svn/",
						"^.hg/",
						"node_modules/",
						"%.DS_Store",
						"%.pyc",
						"%.pyo",
						"%.o",
						"%.a",
						"%.so",
						"%.dylib",
						"%.dll",
						"%.exe",
						"%.jar",
						"%.zip",
						"%.tar",
						"%.gz",
						"%.bz2",
						"%.xz",
						"%.7z",
						"%.rar",
						"%.pdf",
						"%.doc",
						"%.docx",
						"%.xls",
						"%.xlsx",
						"%.ppt",
						"%.pptx",
						"%.jpg",
						"%.jpeg",
						"%.png",
						"%.gif",
						"%.bmp",
						"%.svg",
						"%.ico",
						"%.mp3",
						"%.mp4",
						"%.avi",
						"%.mov",
						"%.wmv",
						"%.flv",
						"%.mkv",
					},

					-- Search configuration
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
						"--glob=!.git/",
					},

					-- Mappings
					mappings = {
						i = {
							["<C-n>"] = actions.cycle_history_next,
							["<C-p>"] = actions.cycle_history_prev,
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-c>"] = actions.close,
							["<Down>"] = actions.move_selection_next,
							["<Up>"] = actions.move_selection_previous,
							["<CR>"] = actions.select_default,
							["<C-x>"] = actions.select_horizontal,
							["<C-v>"] = actions.select_vertical,
							["<C-t>"] = actions.select_tab,
							["<C-u>"] = actions.preview_scrolling_up,
							["<C-d>"] = actions.preview_scrolling_down,
							["<PageUp>"] = actions.results_scrolling_up,
							["<PageDown>"] = actions.results_scrolling_down,
							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-l>"] = actions.complete_tag,
							["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
							["<C-r><C-w>"] = actions.insert_original_cword,
							-- Open with trouble if available
							["<C-t>"] = trouble and open_with_trouble or actions.select_tab,
						},
						n = {
							["<esc>"] = actions.close,
							["<CR>"] = actions.select_default,
							["<C-x>"] = actions.select_horizontal,
							["<C-v>"] = actions.select_vertical,
							["<C-t>"] = actions.select_tab,
							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["j"] = actions.move_selection_next,
							["k"] = actions.move_selection_previous,
							["H"] = actions.move_to_top,
							["M"] = actions.move_to_middle,
							["L"] = actions.move_to_bottom,
							["<Down>"] = actions.move_selection_next,
							["<Up>"] = actions.move_selection_previous,
							["gg"] = actions.move_to_top,
							["G"] = actions.move_to_bottom,
							["<C-u>"] = actions.preview_scrolling_up,
							["<C-d>"] = actions.preview_scrolling_down,
							["<PageUp>"] = actions.results_scrolling_up,
							["<PageDown>"] = actions.results_scrolling_down,
							["?"] = actions.which_key,
							-- Open with trouble if available
							["<C-t>"] = trouble and open_with_trouble or actions.select_tab,
						},
					},

					-- Performance
					cache_picker = {
						num_pickers = 3,
					},

					-- History
					history = {
						path = vim.fn.stdpath("data") .. "/telescope_history.sqlite3",
						limit = 100,
					},

					-- Preview configuration
					preview = {
						msg_bg_fillchar = "╱",
						treesitter = true,
						timeout = 250,
						filesize_limit = 25, -- MB
						highlight_limit = 4096, -- bytes
					},

					-- Border and window configuration
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },

					-- Path display
					path_display = { "truncate" },

					-- Winblend
					winblend = 0,

					-- Color devicons
					color_devicons = true,

					-- Use regex
					use_less = true,

					-- Set environment variables
					set_env = { ["COLORTERM"] = "truecolor" },
				},
				pickers = {
					find_files = {
						find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
						follow = true,
						hidden = true,
					},
					live_grep = {
						additional_args = function(opts)
							return { "--hidden", "--glob", "!**/.git/*" }
						end,
					},
					buffers = {
						show_all_buffers = true,
						sort_lastused = true,
						sort_mru = true,
						mappings = {
							i = {
								["<C-d>"] = actions.delete_buffer,
							},
							n = {
								["dd"] = actions.delete_buffer,
							},
						},
					},
					oldfiles = {
						cwd_only = true,
					},
					grep_string = {
						additional_args = function(opts)
							return { "--hidden", "--glob", "!**/.git/*" }
						end,
					},
					git_files = {
						show_untracked = true,
					},
					lsp_references = {
						trim_text = true,
					},
					lsp_definitions = {
						trim_text = true,
					},
					lsp_implementations = {
						trim_text = true,
					},
					lsp_document_symbols = {
						symbol_width = 50,
					},
					lsp_workspace_symbols = {
						symbol_width = 50,
					},
					diagnostics = {
						theme = "ivy",
						initial_mode = "normal",
					},
					quickfix = {
						theme = "ivy",
					},
					loclist = {
						theme = "ivy",
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})

			-- Load extensions
			pcall(telescope.load_extension, "fzf")

			-- Load other extensions if they exist
			local extensions = { "ui-select", "project", "notify", "noice" }
			for _, ext in ipairs(extensions) do
				pcall(telescope.load_extension, ext)
			end
		end,
	},
}

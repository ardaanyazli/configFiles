return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		winopts = {
			border = "rounded",
			preview = {
				default = "builtin",
			},
		},
	},
	keys = {
		-- File operations
		{
			"<leader>ff",
			function()
				require("fzf-lua").files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>fg",
			function()
				require("fzf-lua").live_grep()
			end,
			desc = "Live Grep",
		},
		{
			"<leader>fb",
			function()
				require("fzf-lua").buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>fh",
			function()
				require("fzf-lua").help_tags()
			end,
			desc = "Help Tags",
		},
		{
			"<leader>fr",
			function()
				require("fzf-lua").oldfiles()
			end,
			desc = "Recent Files",
		},
		{
			"<leader>fc",
			function()
				require("fzf-lua").commands()
			end,
			desc = "Commands",
		},
		{
			"<leader>fk",
			function()
				require("fzf-lua").keymaps()
			end,
			desc = "Keymaps",
		},
		{
			"<leader>fs",
			function()
				require("fzf-lua").blines()
			end,
			desc = "Search in Buffer",
		},
		{
			"<leader>fw",
			function()
				require("fzf-lua").grep_cword()
			end,
			desc = "Find Word Under Cursor",
		},
		{
			"<leader>fd",
			function()
				require("fzf-lua").diagnostics_document()
			end,
			desc = "Diagnostics",
		},
		{
			"<leader>fq",
			function()
				require("fzf-lua").quickfix()
			end,
			desc = "Quickfix List",
		},
		{
			"<leader>fl",
			function()
				require("fzf-lua").loclist()
			end,
			desc = "Location List",
		},
		{
			"<leader>fj",
			function()
				require("fzf-lua").jumps()
			end,
			desc = "Jump List",
		},
		{
			"<leader>fm",
			function()
				require("fzf-lua").marks()
			end,
			desc = "Marks",
		},
		{
			"<leader>ft",
			function()
				require("fzf-lua").treesitter()
			end,
			desc = "Treesitter Symbols",
		},
		{
			"<leader>fp",
			function()
				require("fzf-lua").resume()
			end,
			desc = "Resume Previous Search",
		},

		-- Git related
		{
			"<leader>gc",
			function()
				require("fzf-lua").git_commits()
			end,
			desc = "Git Commits",
		},
		{
			"<leader>gb",
			function()
				require("fzf-lua").git_branches()
			end,
			desc = "Git Branches",
		},
		{
			"<leader>gs",
			function()
				require("fzf-lua").git_status()
			end,
			desc = "Git Status",
		},
		{
			"<leader>gf",
			function()
				require("fzf-lua").git_files()
			end,
			desc = "Git Files",
		},

		-- LSP related
		{
			"<leader>lr",
			function()
				require("fzf-lua").lsp_references()
			end,
			desc = "LSP References",
		},
		{
			"<leader>ld",
			function()
				require("fzf-lua").lsp_definitions()
			end,
			desc = "LSP Definitions",
		},
		{
			"<leader>li",
			function()
				require("fzf-lua").lsp_implementations()
			end,
			desc = "LSP Implementations",
		},
		{
			"<leader>lt",
			function()
				require("fzf-lua").lsp_typedefs()
			end,
			desc = "LSP Type Definitions",
		},
		{
			"<leader>ls",
			function()
				require("fzf-lua").lsp_document_symbols()
			end,
			desc = "Document Symbols",
		},
		{
			"<leader>lw",
			function()
				require("fzf-lua").lsp_workspace_symbols()
			end,
			desc = "Workspace Symbols",
		},
		{
			"<leader>lc",
			function()
				require("fzf-lua").lsp_incoming_calls()
			end,
			desc = "Incoming Calls",
		},
		{
			"<leader>lo",
			function()
				require("fzf-lua").lsp_outgoing_calls()
			end,
			desc = "Outgoing Calls",
		},
	},
}

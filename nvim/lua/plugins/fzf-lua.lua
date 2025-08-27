return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local fzf = require("fzf-lua")
		fzf.setup({
			winopts = {
				border = "rounded",
				preview = {
					default = "bat",
				},
			},
		})

		-- File operations
		vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find Files" })
		vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live Grep" })
		vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
		vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Help Tags" })
		vim.keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "Recent Files" })
		vim.keymap.set("n", "<leader>fc", fzf.commands, { desc = "Commands" })
		vim.keymap.set("n", "<leader>fk", fzf.keymaps, { desc = "Keymaps" })
		vim.keymap.set("n", "<leader>fs", fzf.blines, { desc = "Search in Buffer" })
		vim.keymap.set("n", "<leader>fw", fzf.grep_cword, { desc = "Find Word Under Cursor" })
		vim.keymap.set("n", "<leader>fd", fzf.diagnostics_document, { desc = "Diagnostics" })
		vim.keymap.set("n", "<leader>fq", fzf.quickfix, { desc = "Quickfix List" })
		vim.keymap.set("n", "<leader>fl", fzf.loclist, { desc = "Location List" })
		vim.keymap.set("n", "<leader>fj", fzf.jumps, { desc = "Jump List" })
		vim.keymap.set("n", "<leader>fm", fzf.marks, { desc = "Marks" })
		vim.keymap.set("n", "<leader>ft", fzf.treesitter, { desc = "Treesitter Symbols" })
		vim.keymap.set("n", "<leader>fp", fzf.resume, { desc = "Resume Previous Search" })

		-- Git related
		vim.keymap.set("n", "<leader>gc", fzf.git_commits, { desc = "Git Commits" })
		vim.keymap.set("n", "<leader>gb", fzf.git_branches, { desc = "Git Branches" })
		vim.keymap.set("n", "<leader>gs", fzf.git_status, { desc = "Git Status" })
		vim.keymap.set("n", "<leader>gf", fzf.git_files, { desc = "Git Files" })

		-- LSP related
		vim.keymap.set("n", "<leader>lr", fzf.lsp_references, { desc = "LSP References" })
		vim.keymap.set("n", "<leader>ld", fzf.lsp_definitions, { desc = "LSP Definitions" })
		vim.keymap.set("n", "<leader>li", fzf.lsp_implementations, { desc = "LSP Implementations" })
		vim.keymap.set("n", "<leader>lt", fzf.lsp_typedefs, { desc = "LSP Type Definitions" })
		vim.keymap.set("n", "<leader>ls", fzf.lsp_document_symbols, { desc = "Document Symbols" })
		vim.keymap.set("n", "<leader>lw", fzf.lsp_workspace_symbols, { desc = "Workspace Symbols" })
		vim.keymap.set("n", "<leader>lc", fzf.lsp_incoming_calls, { desc = "Incoming Calls" })
		vim.keymap.set("n", "<leader>lo", fzf.lsp_outgoing_calls, { desc = "Outgoing Calls" })
	end,
}

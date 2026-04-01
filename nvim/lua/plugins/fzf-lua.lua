local fzf = require("fzf-lua").setup({
	winopts = {
		border = "rounded",
		preview = {
			default = "builtin",
		},
	},
})

vim.keymap.set("n", "<leader>ff", function()
	fzf.files()
end, { desc = "FZF Files" })
vim.keymap.set("n", "<leader>fg", function()
	fzf.live_grep()
end, { desc = "FZF Live Grep" })
vim.keymap.set("n", "<leader>fb", function()
	fzf.buffers()
end, { desc = "FZF Buffers" })
vim.keymap.set("n", "<leader>fh", function()
	fzf.help_tags()
end, { desc = "FZF Help Tags" })
vim.keymap.set("n", "<leader>fx", function()
	fzf.diagnostics_document()
end, { desc = "FZF Diagnostics Document" })
vim.keymap.set("n", "<leader>fX", function()
	fzf.diagnostics_workspace()
end, { desc = "FZF Diagnostics Workspace" })

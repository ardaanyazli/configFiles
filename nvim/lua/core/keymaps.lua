vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Go to next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Go to previous buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete current buffer" })
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "Save current buffer to file" })
vim.keymap.set("n", "<C-D-h>", "<C-w>left", { desc = "Move to left split" })
vim.keymap.set("n", "<C-D-j>", "<C-w>down", { desc = "Move to down split" })
vim.keymap.set("n", "<C-D-k>", "<C-w>up", { desc = "Move to up split" })
vim.keymap.set("n", "<C-D-l>", "<C-w>right", { desc = "Move to right split" })


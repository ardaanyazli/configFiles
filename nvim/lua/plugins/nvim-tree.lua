return {
    'nvim-tree/nvim-tree.lua',
    version = '*',  -- use the latest stable version
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
		local keymap =vim.keymap
        keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
        keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle NvimTree on current open file" })
        keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Collapse file explorer" })
        keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Refresh file explorer" })
        -- Setup nvim-tree with options
        require("nvim-tree").setup({
            sort = {
                sorter = "case_sensitive",
            },
            view = {
                width = 30,
            },
            renderer = {
                group_empty = true,
				indent_markers= {
				enable = true
				}
            },
            filters = {
                dotfiles = true,
            },
        })
    end,
}


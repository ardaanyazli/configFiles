return {
	{
		"tpope/vim-dadbod",
		lazy = true,
		cmd = { "DB", "DBUI", "DBUIToggle", "DBUIAddConnection" },
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_save_location = "~/.config/nvim/db_ui"
		end,
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			"tpope/vim-dadbod",
		},
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
		keys = {
			{ "<leader>uB", "<cmd>DBUIToggle<CR>", mode = "n", desc = "Toggle Dadbod UI" },
		},
	},
	{
		"kristijanhusak/vim-dadbod-completion",
		ft = { "sql", "mysql", "plsql", "psql" },
		dependencies = { "tpope/vim-dadbod" },
		config = function()
			vim.cmd([[
        autocmd FileType sql,mysql,plsql setlocal omnifunc=vim_dadbod_completion#omni
      ]])
		end,
	},
}

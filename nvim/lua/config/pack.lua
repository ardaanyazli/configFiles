-- ============================================================================
-- PLUGINS (vim.pack)
-- ============================================================================
vim.pack.add({
	"https://www.github.com/lewis6991/gitsigns.nvim",
	"https://www.github.com/echasnovski/mini.nvim",
	"https://www.github.com/ibhagwan/fzf-lua",
	"https://www.github.com/nvim-tree/nvim-tree.lua",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},
	-- Language Server Protocols
	"https://www.github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	-- "https://github.com/creativenull/efmls-configs-nvim",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
	"https://github.com/L3MON4D3/LuaSnip",
})
-- local function packadd(name)
-- 	vim.cmd("packadd " .. name)
-- end
-- packadd("nvim-treesitter")
-- packadd("gitsigns.nvim")
-- packadd("mini.nvim")
-- packadd("fzf-lua")
-- packadd("nvim-tree.lua")
-- -- LSP
-- packadd("nvim-lspconfig")
-- packadd("mason.nvim")
-- -- packadd("efmls-configs-nvim")
-- packadd("blink.cmp")
-- packadd("LuaSnip")

local plugin_dir = vim.fn.stdpath("config") .. "/lua/plugins"
local files = vim.fn.readdir(plugin_dir)

for _, file in ipairs(files) do
  if file:match("%.lua$") then
    local module = "plugins." .. file:gsub("%.lua$", "")
    pcall(require, module)
  end
end

return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts =
		{
			style = "night",
			transparent = false,
			terminal_colors = true,
			styles = {
				comments = { italic = true },
				sidebars = "dark",
				floats = "dark",
			},
		}
	},
	{
		"Mofiqul/vscode.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			-- Alternatively set style in setup
			-- style = 'light'

			-- Enable transparent background
			transparent = true,

			-- Enable italic comment
			italic_comments = true,

			-- Enable italic inlay type hints
			italic_inlayhints = true,

			-- Underline `@markup.link.*` variants
			underline_links = true,

			-- Disable nvim-tree background color
			disable_nvimtree_bg = true,

			-- Apply theme colors to terminal
			terminal_colors = true,

			-- Override colors (see ./lua/vscode/colors.lua)
			-- color_overrides = {
			-- 	vscLineNumber = '#FFFFFF',
			-- },
			--
			-- -- Override highlight groups (see ./lua/vscode/theme.lua)
			-- group_overrides = {
			-- 	-- this supports the same val table as vim.api.nvim_set_hl
			-- 	-- use colors from this colorscheme by requiring vscode.colors!
			-- 	Cursor = { fg = require("vscode.colors").get_colors().vscDarkBlue, bg = require("vscode.colors").get_colors().vscLightGreen, bold = true },
			-- }

			-- style = "dark",
			-- group_overrides = {
			--
			-- 	-- This re-color is based on Mofiqul/vscode
			-- 	-- Just a small recoloring to make it look like JetBrains Rider Dark
			--
			-- 	-- Variables
			-- 	["@variable"] = { fg = "#bdbdbd" },
			-- 	["@variable.c_sharp"] = { link = "@variable" },
			-- 	["@variable.member.c_sharp"] = { fg = "#65c3cc" },
			-- 	["@variable.parameter"] = { fg = "#ed8796" },
			-- 	["@variable.parameter.c_sharp"] = { link = "@variable.parameter" },
			--
			-- 	["@keyword.repeat"] = { fg = "#6c95eb", bold = true },
			-- 	["@keyword.repeat.c_sharp"] = { link = "@keyword.repeat" },
			--
			-- 	-- Boolean
			-- 	["@boolean"] = { fg = "#6c95eb", italic = true },
			-- 	["@boolean.c_sharp"] = { link = "@boolean" },
			--
			-- 	-- Return
			-- 	["@keyword.return"] = { fg = "#6c95eb" },
			-- 	["@keyword.return.c_sharp"] = { link = "@keyword.return" },
			--
			-- 	-- Method
			-- 	["@function.method"] = { fg = "#38c596", bold = true },
			-- 	["@function.method.call"] = { link = "@function.method" },
			-- 	["@function.method.call.c_sharp"] = { link = "@function.method" },
			--
			-- 	-- Types (mots clés)
			-- 	["@keyword"] = { fg = "#6c95eb", italic = false },
			-- 	["@keyword.conditional"] = { fg = "#6c95eb", italic = false },
			-- 	["@keyword.conditional.c_sharp"] = { link = "@keyword.conditional" },
			--
			-- 	-- Classes
			-- 	["@lsp.type.class.cs"] = { fg = "#c191ff", bold = true },
			--
			-- 	-- Number
			-- 	["@number"] = { fg = "#e791bc", bold = true },
			-- 	["@number.c_sharp"] = { link = "@number" },
			--
			-- 	-- Comment
			-- 	["Comment"] = { fg = "#84c26b", italic = true },
			-- },
		},
	},
}

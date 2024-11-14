return {
    'Mofiqul/vscode.nvim',
    config = function()
        local c = require('vscode.colors').get_colors()
		vim.opt.background='dark'
        require('vscode').setup({
            transparent = true,            -- Enable transparent background
            italic_comments = true,        -- Enable italic comments
            underline_links = true,        -- Underline `@markup.link.*` variants
            disable_nvimtree_bg = true,    -- Disable nvim-tree background color

            -- Override colors
            color_overrides = {
                vscLineNumber = '#FFFFFF',
            },

            -- Override highlight groups
            group_overrides = {
                Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
            }
        })

        -- Load the theme without affecting devicon colors.
        vim.cmd.colorscheme "vscode"
    end,
}


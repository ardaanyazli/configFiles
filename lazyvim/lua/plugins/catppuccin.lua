return {
  "catppuccin/nvim",
  name = "catppuccin",
  opts = {
    flavour = "frappe", -- Choose: latte, frappe, macchiato, mocha
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
      telescope = true,
      which_key = true,
      notify = true,
      mini = true,
      lsp_trouble = true,
    },
  },
}

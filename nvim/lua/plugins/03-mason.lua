vim.pack.add({
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/seblyng/roslyn.nvim",
})

-- Mason MUST be setup before roslyn
require("mason").setup({
  registries = {
    "github:mason-org/mason-registry",
    "github:Crashdummyy/mason-registry",  -- required for roslyn
  },
})

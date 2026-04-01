vim.pack.add({
	"https://www.github.com/echasnovski/mini.nvim",
})
require("mini.ai").setup({})
require("mini.comment").setup({})
require("mini.move").setup({})
require("mini.surround").setup({})
require("mini.cursorword").setup({})
require("mini.indentscope").setup({
draw = {
    animation = require("mini.indentscope").gen_animation.none(),
  }})
  require("mini.pairs").setup({})
require("mini.trailspace").setup({})
require("mini.bufremove").setup({})
require("mini.notify").setup({})
require("mini.icons").setup({})

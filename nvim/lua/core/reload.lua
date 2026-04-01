local M = {}

-- clear lua cache
local function unload_lua_modules(prefix)
  for name, _ in pairs(package.loaded) do
    if name:match("^" .. prefix) then
      package.loaded[name] = nil
    end
  end
end

-- clear autocmds
local function clear_autocmds()
  vim.api.nvim_clear_autocmds({})
end

-- clear keymaps (optional but safer)
local function clear_keymaps()
  for _, map in ipairs(vim.api.nvim_get_keymap("n")) do
    pcall(vim.keymap.del, "n", map.lhs)
  end
end

M.reload = function()
  -- optional safety resets
  clear_autocmds()
  clear_keymaps()

  -- unload your config namespace
  unload_lua_modules("core")
  unload_lua_modules("plugins")
  unload_lua_modules("lsp")
  unload_lua_modules("user")

  -- reload everything
  require("config")

  vim.notify("Config reloaded ⚡")
end

return M

-- ============================================================================
-- PLUGINS (vim.pack)
-- ============================================================================
local dir = vim.fn.stdpath("config") .. "/lua/plugins"
for _, file in ipairs(vim.fn.readdir(dir)) do
  if file:match("%.lua$") and file ~= "init.lua" then
    require("plugins." .. file:gsub("%.lua$", ""))
  end
end


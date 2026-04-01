-- ============================================================================
-- DAP (Debug Adapter Protocol)
-- ============================================================================
vim.pack.add({
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/rcarriga/nvim-dap-ui",
  "https://github.com/nvim-neotest/nvim-nio", -- required by nvim-dap-ui
  "https://github.com/theHamsta/nvim-dap-virtual-text",
  "https://github.com/jay-babu/mason-nvim-dap.nvim",
})

-- Load lazily — only when a debug keymap is first triggered
local loaded = false
local function load_dap()
  if loaded then return end
  loaded = true

  local dap = require("dap")
  local dapui = require("dapui")

  -- ── nvim-dap-virtual-text ─────────────────────────────────────────────────
  require("nvim-dap-virtual-text").setup({
    commented = true, -- show virtual text alongside comment
  })

  -- ── dapui ─────────────────────────────────────────────────────────────────
  dapui.setup({
    icons = { expanded = "", collapsed = "", current_frame = "" },
    layouts = {
      {
        elements = {
          { id = "scopes",      size = 0.40 },
          { id = "breakpoints", size = 0.20 },
          { id = "stacks",      size = 0.20 },
          { id = "watches",     size = 0.20 },
        },
        size = 40,
        position = "left",
      },
      {
        elements = {
          { id = "repl",    size = 0.5 },
          { id = "console", size = 0.5 },
        },
        size = 10,
        position = "bottom",
      },
    },
  })

  -- ── auto open/close UI with session ───────────────────────────────────────
  dap.listeners.before.attach.dapui_config = function() dapui.open() end
  dap.listeners.before.launch.dapui_config = function() dapui.open() end
  dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
  dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

  -- ── mason-nvim-dap: auto install adapters ─────────────────────────────────
  -- Add any adapters you need to ensure_installed.
  -- Run :MasonInstall <adapter> manually or list them here.
  require("mason-nvim-dap").setup({
    ensure_installed = {
       "coreclr",    -- C# / .NET  (pairs well with roslyn)
      -- "python",     -- Python (debugpy)
      -- "codelldb",   -- Rust / C / C++
      -- "js-debug-adapter", -- JavaScript / TypeScript
    },
    automatic_installation = true,
    handlers = {}, -- use default handlers per adapter
  })

  -- ── DAP signs ─────────────────────────────────────────────────────────────
  vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DiagnosticError" })
  vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
  vim.fn.sign_define("DapBreakpointRejected",  { text = "○", texthl = "DiagnosticHint" })
  vim.fn.sign_define("DapLogPoint",            { text = "◎", texthl = "DiagnosticInfo" })
  vim.fn.sign_define("DapStopped",             { text = "→", texthl = "DiagnosticOk", linehl = "DiffAdd", numhl = "DiagnosticOk" })
end

-- ── Keymaps (trigger load on first use) ───────────────────────────────────────
local function map(lhs, action, desc)
  vim.keymap.set("n", lhs, function()
    load_dap()
    action()
  end, { desc = desc })
end

map("<F5>",       function() require("dap").continue() end,           "DAP: Continue")
map("<F10>",      function() require("dap").step_over() end,          "DAP: Step Over")
map("<F11>",      function() require("dap").step_into() end,          "DAP: Step Into")
map("<F12>",      function() require("dap").step_out() end,           "DAP: Step Out")
map("<leader>db", function() require("dap").toggle_breakpoint() end,  "DAP: Toggle Breakpoint")
map("<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "DAP: Conditional Breakpoint")
map("<leader>dl", function()
  require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, "DAP: Log Point")
map("<leader>dr", function() require("dap").repl.open() end,          "DAP: Open REPL")
map("<leader>du", function() require("dapui").toggle() end,           "DAP: Toggle UI")
map("<leader>de", function() require("dapui").eval() end,             "DAP: Evaluate Expression")
map("<leader>dx", function() require("dap").terminate() end,          "DAP: Terminate")

-- Visual mode eval
vim.keymap.set("v", "<leader>de", function()
  load_dap()
  require("dapui").eval()
end, { desc = "DAP: Evaluate Selection" })

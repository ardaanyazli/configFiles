local keymapOpts = { noremap = true, silent = true }
local function pick_csproj()
	local projects = vim.fn.glob("**/*.csproj", true, true)

	if #projects == 0 then
		error("No .csproj files found")
	end

	local choice = vim.fn.inputlist(vim.list_extend(
		{ "Select project:" },
		vim.tbl_map(function(p) return p end, projects)
	))

	if choice < 1 or choice > #projects then
		error("Invalid project selection")
	end

	return projects[choice]
end

local function project_root_from_csproj(csproj)
	return vim.fn.fnamemodify(csproj, ":h")
end

local last_csproj

local function get_csproj()
	if last_csproj then return last_csproj end
	last_csproj = pick_csproj()
	return last_csproj
end
return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			-----------------------------------------------------------------------
			-- Signs
			-----------------------------------------------------------------------
			vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticWarn" })
			vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo" })
			vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticHint", linehl = "Visual" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticError" })
			local dap = require("dap")

			local mason_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"

			local netcoredbg_adapter = {
				type = "executable",
				command = mason_path,
				args = { "--interpreter=vscode" },
			}

			dap.adapters.netcoredbg = netcoredbg_adapter -- needed for normal debugging
			dap.adapters.coreclr = netcoredbg_adapter -- needed for unit test debugging

			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "launch - netcoredbg",
					request = "launch",
					program = function()
						local result = vim.system(
							{ "dotnet", "build" },
							{ cwd = vim.fn.getcwd(), text = true }
						):wait()

						if result.code ~= 0 then
							vim.notify(result.stderr ~= "" and result.stderr or result.stdout,
								vim.log.levels.ERROR,
								{ title = "dotnet build failed" }
							)
							return nil -- IMPORTANT: don't throw Lua error
						end
						-- return require("dap-dll-autopicker").build_dll_path()
						return get_csproj()
					end,
					env = function()
						local choice = vim.fn.inputlist({
							"Select environment:",
							"1. Development",
							"2. Production",
						})

						local map = {
							[1] = "Development",
							[2] = "Production",
						}

						local selected = map[choice] or "Development"

						return {
							ASPNETCORE_ENVIRONMENT = selected,
							DOTNET_ENVIRONMENT = selected,
						}
					end,
					-- justMyCode = false,
					-- stopAtEntry = false,
					-- -- program = function()
					-- --   -- todo: request input from ui
					-- --   return "/path/to/your.dll"
					-- -- end,
					-- env = {
					--   ASPNETCORE_ENVIRONMENT = function()
					--     -- todo: request input from ui
					--     return "Development"
					--   end,
					--   ASPNETCORE_URLS = function()
					--     -- todo: request input from ui
					--     return "http://localhost:5050"
					--   end,
					-- },
					cwd = function()
						-- todo: request input from ui
						return project_root_from_csproj(get_csproj())
					end,
				},
			}

			-- local map = vim.keymap.set
			-- map("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>", opts)
			-- map("n", "<F6>", "<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>", opts)
			-- map("n", "<F9>", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
			-- map("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>", opts)
			-- map("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>", opts)
			-- map("n", "<F8>", "<Cmd>lua require'dap'.step_out()<CR>", opts)
			-- -- map("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>", opts)
			-- map("n", "<leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", opts)
			-- map("n", "<leader>dl", "<Cmd>lua require'dap'.run_last()<CR>", opts)
			-- map("n", "<leader>dt", "<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>",
			-- 	{ noremap = true, silent = true, desc = 'debug nearest test' })



			-- -----------------------------------------------------------------------
			-- -- Adapter (netcoredbg)
			-- -----------------------------------------------------------------------
			-- local netcoredbg = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"
			-- dap.adapters.coreclr = {
			-- 	type = "executable",
			-- 	command = netcoredbg,
			-- 	args = { "--interpreter=vscode" },
			-- }
			--
			-- -----------------------------------------------------------------------
			-- -- Configurations
			-- -----------------------------------------------------------------------
			-- dap.configurations.cs = config
			--
			-----------------------------------------------------------------------
			-- Keymaps (Visual Studio style)
			-----------------------------------------------------------------------
			vim.keymap.set("n", "<F5>", dap.continue,
				vim.tbl_extend("force", keymapOpts, { desc = "Debug: Start/Continue" }))
			vim.keymap.set("n", "<S-F5>", dap.terminate, vim.tbl_extend("force", keymapOpts, { desc = "Debug: Stop" }))
			vim.keymap.set("n", "<C-S-F5>", dap.restart, vim.tbl_extend("force", keymapOpts, { desc = "Debug: Restart" }))
			vim.keymap.set("n", "<F9>", dap.toggle_breakpoint,
				vim.tbl_extend("force", keymapOpts, { desc = "Debug: Toggle Breakpoint" }))
			vim.keymap.set("n", "<C-S-F9>", function()
				dap.clear_breakpoints()
				vim.notify("All breakpoints cleared", vim.log.levels.INFO)
			end, vim.tbl_extend("force", keymapOpts, { desc = "Debug: Clear All Breakpoints" }))
			vim.keymap.set("n", "<F10>", dap.step_over,
				vim.tbl_extend("force", keymapOpts, { desc = "Debug: Step Over" }))
			vim.keymap.set("n", "<F11>", dap.step_into,
				vim.tbl_extend("force", keymapOpts, { desc = "Debug: Step Into" }))
			vim.keymap.set("n", "<S-F11>", dap.step_out,
				vim.tbl_extend("force", keymapOpts, { desc = "Debug: Step Out" }))
			vim.keymap.set("n", "<C-F10>", dap.run_to_cursor, { desc = "Debug: Run to Cursor" })
			vim.keymap.set("n", "<M-F9>", function()
				dap.set_breakpoint(vim.fn.input("Condition: "))
			end, vim.tbl_extend("force", keymapOpts, { desc = "Debug: Conditional Breakpoint" }))
			vim.keymap.set("n", "<leader>dr", dap.repl.open,
				vim.tbl_extend("force", keymapOpts, { desc = "Debug: Open REPL" }))
		end,
	},

	---------------------------------------------------------------------------
	-- UI
	---------------------------------------------------------------------------
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()

			dap.listeners.after.event_initialized.dapui = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui = function()
				dapui.close()
			end

			vim.keymap.set("n", "<F12>", function() dapui.eval() end,
				vim.tbl_extend("force", keymapOpts, { desc = "inspect under cursor" }))
		end,
	},

	---------------------------------------------------------------------------
	-- Virtual Text
	---------------------------------------------------------------------------
	{
		"theHamsta/nvim-dap-virtual-text",
		config = function()
			require("nvim-dap-virtual-text").setup()
		end,
	},
}

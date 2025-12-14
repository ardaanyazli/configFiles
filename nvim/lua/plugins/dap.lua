vim.g.dotnet_build_project = function()
	local default_path = vim.fn.getcwd() .. '/'
	if vim.g['dotnet_last_proj_path'] ~= nil then
		default_path = vim.g['dotnet_last_proj_path']
	end
	local path = vim.fn.input('Path to your *proj file', default_path, 'file')
	vim.g['dotnet_last_proj_path'] = path
	local cmd = 'dotnet build -c Debug ' .. path .. ' > /dev/null'
	print('')
	print('Cmd to execute: ' .. cmd)
	local f = os.execute(cmd)
	if f == 0 then
		print('\nBuild: ✔️ ')
	else
		print('\nBuild: ❌ (code: ' .. f .. ')')
	end
end

vim.g.dotnet_get_dll_path = function()
	local request = function()
		return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
	end

	if vim.g['dotnet_last_dll_path'] == nil then
		vim.g['dotnet_last_dll_path'] = request()
	else
		if vim.fn.confirm('Do you want to change the path to dll?\n' .. vim.g['dotnet_last_dll_path'], '&yes\n&no', 2) == 1 then
			vim.g['dotnet_last_dll_path'] = request()
		end
	end

	return vim.g['dotnet_last_dll_path']
end

local config = {
	{
		type = "coreclr",
		name = "launch - netcoredbg",
		request = "launch",
		program = function()
			if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
				vim.g.dotnet_build_project()
			end
			return vim.g.dotnet_get_dll_path()
		end,
	},
}
return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")

			-----------------------------------------------------------------------
			-- Signs
			-----------------------------------------------------------------------
			vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticWarn" })
			vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo" })
			vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticHint", linehl = "Visual" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticError" })


			-----------------------------------------------------------------------
			-- Adapter (netcoredbg)
			-----------------------------------------------------------------------
			local netcoredbg = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"
			dap.adapters.coreclr = {
				type = "executable",
				command = netcoredbg,
				args = { "--interpreter=vscode" },
			}

			-----------------------------------------------------------------------
			-- Configurations
			-----------------------------------------------------------------------
			dap.configurations.cs = config

			-----------------------------------------------------------------------
			-- Keymaps (Visual Studio style)
			-----------------------------------------------------------------------
			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
			vim.keymap.set("n", "<S-F5>", dap.terminate, { desc = "Debug: Stop" })
			vim.keymap.set("n", "<C-S-F5>", dap.restart, { desc = "Debug: Restart" })
			vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
			vim.keymap.set("n", "<C-S-F9>", function()
				dap.clear_breakpoints()
				vim.notify("All breakpoints cleared", vim.log.levels.INFO)
			end, { desc = "Debug: Clear All Breakpoints" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
			vim.keymap.set("n", "<S-F11>", dap.step_out, { desc = "Debug: Step Out" })
			vim.keymap.set("n", "<C-F10>", dap.run_to_cursor, { desc = "Debug: Run to Cursor" })
			vim.keymap.set("n", "<M-F9>", function()
				dap.set_breakpoint(vim.fn.input("Condition: "))
			end, { desc = "Debug: Conditional Breakpoint" })
			vim.keymap.set("n", "<Leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })
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
			-- dap.listeners.before.event_terminated.dapui = function()
			-- 	dapui.close()
			-- end
			-- dap.listeners.before.event_exited.dapui = function()
			-- 	dapui.close()
			-- end
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

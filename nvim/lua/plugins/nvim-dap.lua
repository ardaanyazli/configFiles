return {
	-- Debug Adapter Protocol (DAP)
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"rcarriga/nvim-dap-ui", -- UI for nvim-dap
			"theHamsta/nvim-dap-virtual-text", -- Virtual text for DAP
			"jay-babu/mason-nvim-dap.nvim", -- Install DAP debuggers via Mason
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup()
			require("nvim-dap-virtual-text").setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			dap.adapters.coreclr = {
				type = "executable",
				command = require("mason-registry").get_package("netcoredbg"):get_install_path()
					.. "/netcoredbg/netcoredbg",
				args = { "--interpreter=vscode" },
			}

			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "Launch - NetCoreDbg",
					request = "launch",
					program = function()
						return vim.fn.input("Path to DLL > ", vim.fn.getcwd() .. "/bin/Debug/net6.0/MyApp.dll", "file")
					end,
				},
				{
					type = "coreclr",
					name = "Attach - NetCoreDbg",
					request = "attach",
					processId = require("dap.utils").pick_process,
				},
			}
		end,
	},
}

return {
	"mfussenegger/nvim-dap",
	lazy = true,
	dependencies = {
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
		"jay-babu/mason-nvim-dap.nvim",
	},
	keys = {
		{
			"<F5>",
			function()
				require("dap").continue()
			end,
			desc = "Start/Continue Debugging",
		},
		{
			"<F9>",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Toggle Breakpoint",
		},
		{
			"<F10>",
			function()
				require("dap").step_over()
			end,
			desc = "Step Over",
		},
		{
			"<F11>",
			function()
				require("dap").step_into()
			end,
			desc = "Step Into",
		},
		{
			"<S-F11>",
			function()
				require("dap").step_out()
			end,
			desc = "Step Out",
		},
	},
	config = function()
		local dap = require("dap")
		vim.fn.sign_define("DapBreakpoint", {
			text = "", -- Red circle
			texthl = "DiagnosticError",
			linehl = "",
			numhl = "",
		})
		vim.fn.sign_define("DapBreakpointCondition", {
			text = "", -- Question mark for conditional breakpoints
			texthl = "DiagnosticWarn",
			linehl = "",
			numhl = "",
		})
		vim.fn.sign_define("DapLogPoint", {
			text = "", -- Info symbol
			texthl = "DiagnosticInfo",
			linehl = "",
			numhl = "",
		})
		vim.fn.sign_define("DapStopped", {
			text = "", -- Arrow indicator for current line
			texthl = "DiagnosticHint",
			linehl = "Visual",
			numhl = "",
		})
		vim.fn.sign_define("DapBreakpointRejected", {
			text = "", -- Warning triangle for rejected breakpoints
			texthl = "DiagnosticError",
			linehl = "",
			numhl = "",
		})
		-- Setup virtual text
		require("nvim-dap-virtual-text").setup({
			enabled = true,
			enabled_commands = true,
			highlight_changed_variables = true,
			highlight_new_as_changed = false,
			show_stop_reason = true,
			commented = false,
			only_first_definition = true,
			all_references = false,
			clear_on_continue = false,
			display_callback = function(variable, buf, stackframe, node, options)
				if options.virt_text_pos == "inline" then
					return " = " .. variable.value
				else
					return variable.name .. " = " .. variable.value
				end
			end,
			virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
			all_frames = false,
			virt_lines = false,
			virt_text_win_col = nil,
		})
		local netcoredbg_adapter = {
			type = "executable",
			command = mason_path,
			args = { "--interpreter=vscode" },
		}
		-- Configure netcoredbg adapter for .NET debugging
		dap.adapters.coreclr = netcoredbg_adapter;
		-- C# DAP configurations

		dap.configurations.cs = {
			{
				type = "coreclr",
				name = "launch - netcoredbg",
				request = "launch",
				program = function()
					-- return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/src/", "file")
					return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/net9.0/", "file")
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
				-- cwd = function()
				--   -- todo: request input from ui
				--   return vim.fn.getcwd()
				-- end,
			}
		}

		-- Setup Mason DAP for automatic installation
		require("mason-nvim-dap").setup({
			ensure_installed = { "netcoredbg" },
			handlers = {
				function(config)
					require("mason-nvim-dap").default_setup(config)
				end,
			},
		})
	end,
}

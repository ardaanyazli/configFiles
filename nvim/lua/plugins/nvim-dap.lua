return {
	{
		'ramboe/ramboe-dotnet-utils',
		dependencies = { 'mfussenegger/nvim-dap' }
	}, {
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

		dap.adapters.netcoredbg = netcoredbg_adapter -- needed for normal debugging
		dap.adapters.coreclr = netcoredbg_adapter -- needed for unit test debugging

		dap.configurations.cs = {
			{
				type = "coreclr",
				name = "LAUNCH directly from nvim",
				request = "launch",
				program = function()
					return require("dap-dll-autopicker").build_dll_path()
				end
			},
			-- {
			--   type = "coreclr",
			--   name = "ATTACH to running app in dedicated terminal",
			--   request = "attach",
			--   processId = function()
			--     return require("dap.utils").pick_process()
			--   end,
			-- }
		}
	end,
}
}

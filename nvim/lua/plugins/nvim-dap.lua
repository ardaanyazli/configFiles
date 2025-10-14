return {
	"mfussenegger/nvim-dap",
	lazy = true, -- don’t load until needed
	ft = { "go", "cs", "typescript", "javascript", "rust", "lua" }, -- only for these filetypes
	keys = {
		{
			"<F5>",
			function()
				require("dap").continue()
			end,
			desc = "Start/Continue Debugging",
		},
		{
			"<S-F5>",
			function()
				require("dap").terminate()
			end,
			desc = "Terminate Debugging",
		},
		{
			"<F9>",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Toggle Breakpoint",
		},
		{
			"<leader>dB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Condition: "))
			end,
			desc = "Conditional Breakpoint",
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
		{
			"<leader>dr",
			function()
				require("dap").repl.open()
			end,
			desc = "Open REPL",
		},
		{
			"<leader>dl",
			function()
				require("dap").run_last()
			end,
			desc = "Run Last Configuration",
		},
	},

	dependencies = {
		{
			"jay-babu/mason-nvim-dap.nvim",
			cmd = { "DapInstall", "DapUninstall" },
			config = function()
				require("mason-nvim-dap").setup({
					ensure_installed = { "delve", "netcoredbg" },
					handlers = {
						function(config)
							require("mason-nvim-dap").default_setup(config)
						end,
					},
				})
			end,
		},
	},

	config = function()
		local dap = require("dap")

		local dap_signs = {
			DapBreakpoint = {
				text = "",
				texthl = "DiagnosticError",
				linehl = "",
				numhl = "",
			},
			DapBreakpointCondition = {
				text = "",
				texthl = "DiagnosticWarn",
				linehl = "",
				numhl = "",
			},
			DapLogPoint = {
				text = "",
				texthl = "DiagnosticInfo",
				linehl = "",
				numhl = "",
			},
			DapStopped = {
				text = "",
				texthl = "DiagnosticHint",
				linehl = "Visual",
				numhl = "",
			},
			DapBreakpointRejected = {
				text = "",
				texthl = "DiagnosticError",
				linehl = "",
				numhl = "",
			},
		}

		for name, opts in pairs(dap_signs) do
			vim.fn.sign_define(name, opts)
		end
		--------------------------------------------------------------------------
		-- Go Debugging
		--------------------------------------------------------------------------
		dap.adapters.go = {
			type = "server",
			port = "${port}",
			executable = {
				command = "dlv",
				args = { "dap", "-l", "127.0.0.1:${port}" },
			},
		}

		dap.configurations.go = {
			{
				type = "go",
				name = "Debug File",
				request = "launch",
				program = "${file}",
			},
			{
				type = "go",
				name = "Debug Package",
				request = "launch",
				program = "${workspaceFolder}",
			},
			{
				type = "go",
				name = "Attach",
				mode = "local",
				request = "attach",
				processId = require("dap.utils").pick_process,
			},
		}

		--------------------------------------------------------------------------
		-- .NET Debugging
		--------------------------------------------------------------------------
		dap.adapters.coreclr = {
			type = "executable",
			command = "netcoredbg",
			args = { "--interpreter=vscode" },
		}

		dap.configurations.cs = {
			{
				type = "coreclr",
				name = "Launch .NET App",
				request = "launch",
				program = function()
					return vim.fn.input("Path to DLL: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
				end,
			},
			{
				type = "coreclr",
				name = "Attach to Process",
				request = "attach",
				processId = require("dap.utils").pick_process,
			},
		}

		--------------------------------------------------------------------------
		-- Extensible placeholders for other languages
		--------------------------------------------------------------------------
		dap.adapters.node2 = {
			type = "executable",
			command = "node",
			args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
		}

		dap.configurations.typescript = {
			{
				name = "Launch TS file",
				type = "node2",
				request = "launch",
				program = "${file}",
				cwd = vim.fn.getcwd(),
				sourceMaps = true,
				protocol = "inspector",
				console = "integratedTerminal",
			},
		}

		dap.adapters.lldb = {
			type = "executable",
			command = "lldb-vscode",
			name = "lldb",
		}

		dap.configurations.rust = {
			{
				name = "Launch Rust Binary",
				type = "lldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
				end,
				cwd = "${workspaceFolder}",
			},
		}
	end,
}

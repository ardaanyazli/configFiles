return {
	-- Debug Adapter Protocol (DAP)
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		dependencies = {
			"nvim-neotest/nvim-nio",
			"rcarriga/nvim-dap-ui", -- UI for nvim-dap
			"theHamsta/nvim-dap-virtual-text", -- Virtual text for DAP
			"jay-babu/mason-nvim-dap.nvim", -- Install DAP debuggers via Mason
		},
		keys = {
			{
				-- "n",
				"<F5>",
				-- '<cmd>lua require("dap").continue()<CR>',
				-- { noremap = true, silent = true },
				function()
					require("dap").continue()
				end,
			}, -- Start/continue debugging
			{
				"n",
				"<F9>",
				'<cmd>lua require("dap").toggle_breakpoint()<CR>',
				{ noremap = true, silent = true },
			}, -- Toggle breakpoint
			{
				"n",
				"<F10>",
				'<cmd>lua require("dap").step_over()<CR>',
				{ noremap = true, silent = true },
			}, -- Step over
			{
				"n",
				"<F11>",
				'<cmd>lua require("dap").step_into()<CR>',
				{ noremap = true, silent = true },
			}, -- Step into
			{
				"n",
				"<S-F11>",
				'<cmd>lua require("dap").step_out()<CR>',
				{ noremap = true, silent = true },
			}, -- Step out
			{
				"n",
				"<S-F5>",
				'<cmd>lua require("dap").terminate()<CR>',
				{ noremap = true, silent = true },
			},
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup()
			require("nvim-dap-virtual-text").setup({})
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

			local function find_project_root()
				local markers = { ".git", "*.sln", "*.csproj" }
				local cwd = vim.fn.expand("%:p:h")

				while cwd ~= "/" do
					for _, marker in ipairs(markers) do
						local matches = vim.fn.glob(cwd .. "/" .. marker, false, true)
						if #matches > 0 then
							return cwd, matches[1] -- Project root and first matching .csproj file
						end
					end
					cwd = vim.fn.fnamemodify(cwd, ":h")
				end
				return nil, nil
			end

			local function get_bin_debug_path()
				local root, csproj = find_project_root()
				if root and csproj then
					local project_name = vim.fn.fnamemodify(csproj, ":t:r") -- Extract project name
					local bin_path = root .. "/bin/Debug/net8.0/" .. project_name .. ".dll"

					-- Run `dotnet build` before using the DLL
					print("Building project...")
					vim.fn.system("dotnet build " .. csproj)

					if vim.fn.filereadable(bin_path) == 1 then
						return bin_path
					else
						print("Build failed or DLL not found: " .. bin_path)
						return nil
					end
				else
					print("Project root or .csproj file not found")
					return nil
				end
			end
			local function get_env_from_launchsettings(profile)
				local launchsettings_path = find_project_root() or vim.fn.getcwd() .. "/Properties/launchSettings.json"
				local env_vars = {}

				-- Check if the file exists
				if vim.fn.filereadable(launchsettings_path) == 0 then
					print("launchSettings.json not found: " .. launchsettings_path)
					return env_vars
				end

				-- Read the file content
				local file = io.open(launchsettings_path, "r")
				if file then
					local content = file:read("*a")
					file:close()

					-- Decode JSON
					local success, json = pcall(vim.fn.json_decode, content)
					if
						success
						and json.profiles
						and json.profiles[profile]
						and json.profiles[profile].environmentVariables
					then
						env_vars = json.profiles[profile].environmentVariables
					else
						print("Profile '" .. profile .. "' not found in launchSettings.json")
					end
				end

				print(env_vars)

				return env_vars
			end
			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "Launch - NetCoreDbg",
					request = "launch",
					program = function()
						local dll = get_bin_debug_path()
						if dll then
							return dll --vim.fn.input("Path to DLL: ", dll)
						else
							return vim.fn.input("Path to DLL: ", vim.fn.getcwd() .. "/bin/Debug/net8.0/", "file")
						end
					end,
					env = get_env_from_launchsettings(vim.fn.input("Enter profile for launchsettings:")),
					cwd = function()
						local root = find_project_root()
						return root or vim.fn.getcwd()
					end,
					args = {},
					-- 	function()
					-- 	return { "launchSettingsProfile:", vim.fn.input("Enter profile: ") }
					-- end,
					-- console = "integratedTerminal",
					stopAtEntry = false,
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

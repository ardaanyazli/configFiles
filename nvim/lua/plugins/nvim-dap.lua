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
			{
				"<S-F5>",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate Debugging",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Conditional Breakpoint",
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
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- Setup DAP UI
			dapui.setup({
				controls = {
					element = "repl",
					enabled = true,
					icons = {
						disconnect = "",
						pause = "",
						play = "",
						run_last = "",
						step_back = "",
						step_into = "",
						step_out = "",
						step_over = "",
						terminate = "",
					},
				},
				element_mappings = {},
				expand_lines = true,
				floating = {
					border = "single",
					mappings = {
						close = { "q", "<Esc>" },
					},
				},
				force_buffers = true,
				icons = {
					collapsed = "",
					current_frame = "",
					expanded = "",
				},
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						position = "left",
						size = 40,
					},
					{
						elements = {
							{ id = "repl", size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						position = "bottom",
						size = 10,
					},
				},
				mappings = {
					edit = "e",
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					repl = "r",
					toggle = "t",
				},
				render = {
					indent = 1,
					max_value_lines = 100,
				},
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

			-- Auto-open/close DAP UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Configure netcoredbg adapter for .NET debugging
			dap.adapters.coreclr = {
				type = "executable",
				command = "netcoredbg",
				args = { "--interpreter=vscode" },
			}

			-- Utility functions for C# project detection
			local function find_project_root()
				local markers = { ".git", "*.sln", "*.csproj" }
				local cwd = vim.fn.expand("%:p:h")

				while cwd ~= "/" do
					for _, marker in ipairs(markers) do
						local matches = vim.fn.glob(cwd .. "/" .. marker, false, true)
						if #matches > 0 then
							-- Find the .csproj file specifically
							local csproj_files = vim.fn.glob(cwd .. "/*.csproj", false, true)
							if #csproj_files > 0 then
								return cwd, csproj_files[1]
							end
							-- If no .csproj in this directory, return the directory anyway
							return cwd, matches[1]
						end
					end
					cwd = vim.fn.fnamemodify(cwd, ":h")
				end
				return nil, nil
			end

			local function get_target_framework()
				local root, csproj = find_project_root()
				if not csproj or not vim.fn.filereadable(csproj) then
					return "net8.0" -- Default fallback
				end

				local file = io.open(csproj, "r")
				if not file then
					return "net8.0"
				end

				local content = file:read("*a")
				file:close()

				-- Look for TargetFramework in the project file
				local target_framework = content:match("<TargetFramework>([^<]+)</TargetFramework>")
				if target_framework then
					return target_framework
				end

				-- Look for TargetFrameworks (multiple)
				local target_frameworks = content:match("<TargetFrameworks>([^<]+)</TargetFrameworks>")
				if target_frameworks then
					-- Return the first one
					return target_frameworks:match("([^;]+)")
				end

				return "net8.0" -- Default fallback
			end

			local function get_assembly_name()
				local root, csproj = find_project_root()
				if not csproj then
					return nil
				end

				local file = io.open(csproj, "r")
				if not file then
					return vim.fn.fnamemodify(csproj, ":t:r")
				end

				local content = file:read("*a")
				file:close()

				-- Look for AssemblyName in the project file
				local assembly_name = content:match("<AssemblyName>([^<]+)</AssemblyName>")
				if assembly_name then
					return assembly_name
				end

				-- Fallback to project file name
				return vim.fn.fnamemodify(csproj, ":t:r")
			end

			local function get_bin_debug_path()
				local root, csproj = find_project_root()
				if not (root and csproj) then
					return nil
				end

				local target_framework = get_target_framework()
				local assembly_name = get_assembly_name()

				if not assembly_name then
					return nil
				end

				local bin_path = root .. "/bin/Debug/" .. target_framework .. "/" .. assembly_name .. ".dll"

				-- Build the project first
				print("Building project: " .. csproj)
				local build_result = vim.fn.system("dotnet build " .. vim.fn.shellescape(csproj))

				if vim.v.shell_error ~= 0 then
					print("Build failed: " .. build_result)
					return nil
				end

				if vim.fn.filereadable(bin_path) == 1 then
					print("Found assembly: " .. bin_path)
					return bin_path
				else
					print("Assembly not found: " .. bin_path)
					-- Try to find any .dll in the output directory
					local output_dir = root .. "/bin/Debug/" .. target_framework .. "/"
					local dll_files = vim.fn.glob(output_dir .. "*.dll", false, true)
					if #dll_files > 0 then
						-- Filter out system/framework DLLs, prefer the project DLL
						for _, dll in ipairs(dll_files) do
							local dll_name = vim.fn.fnamemodify(dll, ":t:r")
							if dll_name == assembly_name or dll_name:find(assembly_name, 1, true) then
								print("Found alternative assembly: " .. dll)
								return dll
							end
						end
						-- If no exact match, return the first DLL
						print("Using first available DLL: " .. dll_files[1])
						return dll_files[1]
					end
					return nil
				end
			end

			local function get_env_from_launchsettings(profile)
				local root = find_project_root() or vim.fn.getcwd()
				local launchsettings_path = root .. "/Properties/launchSettings.json"
				local env_vars = {}

				-- Check if the file exists
				if vim.fn.filereadable(launchsettings_path) == 0 then
					return env_vars
				end

				-- Read the file content
				local file = io.open(launchsettings_path, "r")
				if not file then
					return env_vars
				end

				local content = file:read("*a")
				file:close()

				-- Remove BOM and normalize line endings
				content = content:gsub("^\xef\xbb\xbf", ""):gsub("\r\n", "\n"):gsub("^%s*", "")

				-- Decode JSON
				local success, json = pcall(vim.fn.json_decode, content)
				if
					success
					and json.profiles
					and json.profiles[profile]
					and json.profiles[profile].environmentVariables
				then
					env_vars = json.profiles[profile].environmentVariables
				end

				return env_vars
			end

			local function get_launch_profiles()
				local root = find_project_root() or vim.fn.getcwd()
				local launchsettings_path = root .. "/Properties/launchSettings.json"

				if vim.fn.filereadable(launchsettings_path) == 0 then
					return {}
				end

				local file = io.open(launchsettings_path, "r")
				if not file then
					return {}
				end

				local content = file:read("*a")
				file:close()

				content = content:gsub("^\xef\xbb\xbf", ""):gsub("\r\n", "\n"):gsub("^%s*", "")

				local success, json = pcall(vim.fn.json_decode, content)
				if success and json.profiles then
					local profiles = {}
					for name, _ in pairs(json.profiles) do
						table.insert(profiles, name)
					end
					return profiles
				end

				return {}
			end

			-- C# DAP configurations
			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "Launch .NET Core App",
					request = "launch",
					program = function()
						local dll = get_bin_debug_path()
						if dll then
							return dll
						else
							return vim.fn.input("Path to DLL: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
						end
					end,
					cwd = function()
						local root = find_project_root()
						return root or vim.fn.getcwd()
					end,
					console = "integratedTerminal",
					stopAtEntry = false,
				},
				{
					type = "coreclr",
					name = "Launch with Profile",
					request = "launch",
					program = function()
						local dll = get_bin_debug_path()
						if dll then
							return dll
						else
							return vim.fn.input("Path to DLL: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
						end
					end,
					env = function()
						local profiles = get_launch_profiles()
						if #profiles == 0 then
							return {}
						end

						-- Create a simple selection if only one profile
						local profile
						if #profiles == 1 then
							profile = profiles[1]
						else
							-- Use vim.ui.select if available, otherwise input
							if vim.ui.select then
								local selected_profile = nil
								vim.ui.select(profiles, {
									prompt = "Select launch profile:",
								}, function(choice)
									selected_profile = choice
								end)
								profile = selected_profile or profiles[1]
							else
								print("Available profiles: " .. table.concat(profiles, ", "))
								profile = vim.fn.input("Enter profile name: ", profiles[1])
							end
						end

						return get_env_from_launchsettings(profile)
					end,
					cwd = function()
						local root = find_project_root()
						return root or vim.fn.getcwd()
					end,
					console = "integratedTerminal",
					stopAtEntry = false,
				},
				{
					type = "coreclr",
					name = "Attach to Process",
					request = "attach",
					processId = require("dap.utils").pick_process,
				},
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
	},
}

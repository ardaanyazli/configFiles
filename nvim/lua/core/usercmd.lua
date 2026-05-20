-- ==========================================================================
--                         VIM.PACK USER COMMANDS
-- ==========================================================================

-- 1. :PackUpdate (Updates all plugins, or a specific one passed as an argument)
-- Supports tab-completion for currently installed plugin names.
vim.api.nvim_create_user_command("PackUpdate", function(opts)
	if opts.args ~= "" then
		-- Update a specific plugin passed as an argument (e.g., :PackUpdate gitsigns.nvim)
		vim.notify("Updating " .. opts.args .. "...", vim.log.levels.INFO)
		vim.pack.update({ opts.args })
	else
		-- Standard behavior: update everything
		vim.notify("Checking for package updates...", vim.log.levels.INFO)
		vim.pack.update()
	end
end, {
	nargs = "?",
	desc = "Update all plugins or a specified plugin",
	complete = function(arg_lead)
		-- Provides tab-completion for installed packages
		local pkgs = vim.pack.get()
		local names = {}
		for _, pkg in ipairs(pkgs) do
			if pkg.spec and pkg.spec.name and vim.startswith(pkg.spec.name, arg_lead) then
				table.insert(names, pkg.spec.name)
			end
		end
		return names
	end,
})

-- 2. :PackDelete (Interactively select a plugin to delete using vim.ui.select)
vim.api.nvim_create_user_command("PackDelete", function()
	local packages = vim.pack.get()
	local items = {}

	for _, pkg in ipairs(packages) do
		if pkg.spec and pkg.spec.name then
			table.insert(items, pkg.spec.name)
		end
	end

	if #items == 0 then
		vim.notify("No packages found to delete.", vim.log.levels.WARN)
		return
	end

	vim.ui.select(items, {
		prompt = "Select a package to delete:",
	}, function(choice)
		if choice then
			local success, err = pcall(function()
				vim.pack.del(choice)
			end)
			if success then
				vim.notify("Successfully deleted package: " .. choice, vim.log.levels.INFO)
				vim.cmd("restart") -- Automatically restarts to apply cleanly
			else
				vim.notify("Failed to delete " .. choice .. ": " .. tostring(err), vim.log.levels.ERROR)
			end
		end
	end)
end, { desc = "Interactively delete an installed plugin" })

-- 3. :PackClean (Deletes all stale/inactive plugins not defined in your init.lua)
vim.api.nvim_create_user_command("PackClean", function()
	local choice = vim.fn.confirm("Delete all inactive packages?", "&Yes\n&No", 2)
	if choice == 1 then
		vim.notify("Cleaning inactive packages...", vim.log.levels.INFO)
		-- Equivalent to native `:packdel ++all`
		vim.cmd("packdel ++all")
	else
		vim.notify("Clean aborted.", vim.log.levels.WARN)
	end
end, { desc = "Purge all inactive packages on disk" })


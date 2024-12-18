require("config.options")
require("config.lazy")
-- Ensure roslyn.nvim is loaded
local roslyn_ok, roslyn = pcall(require, "roslyn")
if not roslyn_ok then
	return
end

-- Auto command to refresh CodeLens dynamically
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
	group = vim.api.nvim_create_augroup("RoslynCodeLensRefresh", { clear = true }),
	pattern = "*.cs", -- Only apply to C# files
	callback = function()
		-- Ensure the current buffer has an LSP client attached
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		for _, client in ipairs(clients) do
			if client.name == "roslyn" then
				vim.lsp.codelens.refresh()
				break
			end
		end
	end,
})

return {
	"MonsieurTib/neonuget",
	config = function()
		require("neonuget").setup({
			-- Optional configuration
			dotnet_path = "~/.dotnet/",
			default_project = nil, -- Auto-detected, or specify path like "./MyProject/MyProject.csproj"
		})
	end,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
}

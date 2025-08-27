return {
	cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
	filetypes = { "cs", "vb" },
	root_markers = { "*.csproj", "*.sln", ".git" },
	settings = {
		FormattingOptions = {
			OrganizeImports = true,
		},
		MsBuild = {
			LoadProjectsOnDemand = false,
		},
		RoslynExtensionsOptions = {
			EnableAnalyzersSupport = true,
			EnableImportCompletion = true,
		},
	},
}

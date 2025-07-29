return {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
	root_markers = { ".git" },
	settings = {
		html = {
			format = {
				templating = true,
				wrapLineLength = 120,
				wrapAttributes = "auto",
			},
			hover = {
				documentation = true,
				references = true,
			},
		},
	},
}

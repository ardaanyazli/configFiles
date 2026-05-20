return {
 	capabilities = require("blink.cmp").get_lsp_capabilities(),
	filetypes={"razor","cs"},
	settings={
		["csharp|background_analysis"]={
			dotnet_analyzer_diagnostics_scope="fullSolution",
			dotnet_compiler_diagnostics_scope="fullSolution"
			},
	}
}


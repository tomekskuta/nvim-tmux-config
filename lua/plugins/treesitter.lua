return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local TSconfig = require("nvim-treesitter.configs")
		TSconfig.setup({
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
			languages = {
				ejs = "html",
			},
			ensure_installed = { "html", "javascript", "typescript", "tsx", "embedded_template" },
		})

		vim.filetype.add({
			extension = {
				ejs = "ejs",
			},
		})
		vim.treesitter.language.register("html", "ejs")
		vim.treesitter.language.register("javascript", "ejs")
		vim.treesitter.language.register("embedded_template", "ejs")
	end,
}

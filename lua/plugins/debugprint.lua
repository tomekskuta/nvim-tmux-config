return {
	"andrewferrier/debugprint.nvim",
	opts = {
		-- keymaps = {
		-- 	normal = {
		-- 		variable_below = "gp",
		-- 		variable_above = "gP",
		-- 	},
		-- 	visual = {
		-- 		variable_below = "gp",
		-- 		variable_above = "gP",
		-- 	},
		-- },
		print_tag = "🛸",
	},
	dependencies = {
		"echasnovski/mini.nvim", -- Needed to enable :ToggleCommentDebugPrints for NeoVim <= 0.9
		"nvim-treesitter/nvim-treesitter", -- Needed to enable treesitter for NeoVim 0.8
	},
	version = "*",
}

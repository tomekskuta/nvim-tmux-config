return {
	"numToStr/Comment.nvim",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	opts = {
		-- add any options here
	},
	lazy = false,
config = function()
	require("ts_context_commentstring").setup({
		enable_autocmd = false, -- Important: disabled here as we're setting via Comment.nvim
	})

	require("Comment").setup({
		pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		ignore = "^$", -- Allow commenting empty lines
	})
end,
}

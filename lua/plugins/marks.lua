return {
	"chentoast/marks.nvim",
	event = "VeryLazy",
	opts = {},
	config = function()
		require("marks").setup({
			mappings = {
        delete_buf = "<leader>md",
			},
		})
	end,
}

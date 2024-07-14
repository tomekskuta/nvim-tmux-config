return {
	"vuki656/package-info.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	config = function()
    local packageInfo = require("package-info")
		packageInfo.setup({})

		vim.keymap.set("n", "<leader>pt", packageInfo.toggle, { silent = true, noremap = true })
		vim.keymap.set("n", "<leader>pd", packageInfo.delete, { silent = true, noremap = true })
		vim.keymap.set("n", "<leader>pi", packageInfo.install, { silent = true, noremap = true })
		vim.keymap.set("n", "<leader>pu", packageInfo.change_version, { silent = true, noremap = true })
	end,
}

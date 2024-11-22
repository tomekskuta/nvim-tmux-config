return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup()

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end)
			vim.keymap.set("n", "<leader>hr", function()
				harpoon:mark():rm_file()
			end)
			vim.keymap.set("n", "<leader>hc", function()
				harpoon:list():clear()
			end)
			vim.keymap.set("n", "<C-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			-- Navigate through harpoon marks
			vim.keymap.set("n", "<leader>hn", function()
				harpoon:list():next()
			end)
			vim.keymap.set("n", "<leader>hp", function()
				harpoon:list():prev()
			end)
		end,
	},
	{
		"pockata/harpoon-highlight-current-file",
		dependencies = { "ThePrimeagen/harpoon" },
		config = function()
			require("harpoon-highlight-current-file").setup()
		end,
	},
}

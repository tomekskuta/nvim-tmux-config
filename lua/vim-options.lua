-- Workaround for neovim 0.12.1 bug: nil TSNode passed to get_node_ranges
-- during injection processing. Fixed upstream, remove when neovim is updated.
vim.schedule(function()
	local LanguageTree = require("vim.treesitter.languagetree")
	local orig = LanguageTree._get_injection
	LanguageTree._get_injection = function(self, match, metadata)
		local safe_match = {}
		for id, nodes in pairs(match) do
			local safe_nodes = {}
			for _, node in ipairs(nodes) do
				if node ~= nil then
					safe_nodes[#safe_nodes + 1] = node
				end
			end
			safe_match[id] = safe_nodes
		end
		return orig(self, safe_match, metadata)
	end
end)

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number")
vim.cmd("set relativenumber")
vim.g.mapleader = " "

vim.api.nvim_set_keymap("n", "<C-k>", ":wincmd k<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", ":wincmd j<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-h>", ":wincmd h<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", ":wincmd l<CR>", { silent = true })

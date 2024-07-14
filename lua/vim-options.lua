vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number")
vim.cmd("set relativenumber")
vim.g.mapleader = " "

vim.api.nvim_set_keymap('n', '<C-k>', ':wincmd k<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-j>', ':wincmd j<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-h>', ':wincmd h<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-l>', ':wincmd l<CR>', {silent = true})


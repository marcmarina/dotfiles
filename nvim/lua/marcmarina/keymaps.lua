local opts = { noremap = true, silent = true }

-- Keymap helper
local keymap = vim.api.nvim_set_keymap

-- Remap leader
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal -- 
-- Split navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)


keymap("n", "<leader>e", ":Lex 30<cr>", opts)

local opts = { noremap = true, silent = true }

-- Keymap helper
local keymap = vim.api.nvim_set_keymap

-- Remap leader
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Split navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Explore
keymap("n", "<leader>e", ":Lex 30<cr>", opts)

-- Telescope
keymap("n", "<leader>g", ":Telescope git_files<CR>", opts)
keymap("n", "<leader>b", ":Telescope buffers<CR>", opts)
keymap("n", "<leader>p", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>t", ":Telescope<CR>", opts)

-- Resizing
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize +2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize -2<CR>", opts)

-- Buffer navigation
keymap("n", "<S-h>", ":bnext<CR>", opts)
keymap("n", "<S-l>", ":bprevious<CR>", opts)

-- Indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Save file
keymap("n", "<C-s>", ":w<CR>", opts)

-- Paste without yank
keymap("v", "p", '"_dP', opts)


-- NERDCommenter
keymap("n", "++", "<Plug>NERDCommenterToggle", opts)
keymap("v", "++", "<Plug>NERDCommenterToggle", opts)

-- Alpha
keymap("n", "<leader>m", ":Alpha <CR>", opts)

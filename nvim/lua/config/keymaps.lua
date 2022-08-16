local mapkey = require("helpers.keymaps")

-- Remap leader
mapkey("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Split navigation
mapkey("n", "<C-h>", "<C-w>h")
mapkey("n", "<C-j>", "<C-w>j")
mapkey("n", "<C-k>", "<C-w>k")
mapkey("n", "<C-l>", "<C-w>l")

-- Explore
mapkey("n", "<leader>e", ":NvimTreeFindFileToggle<CR>")

-- Telescope
mapkey("n", "<leader>g", ":Telescope git_files<CR>")
mapkey("n", "<leader>b", ":Telescope buffers<CR>")
mapkey("n", "<leader>p", ":Telescope find_files<CR>")
mapkey("n", "<C-p>", ":Telescope<CR>")

-- Resizing
mapkey("n", "<C-Up>", ":resize +2<CR>")
mapkey("n", "<C-Down>", ":resize -2<CR>")
mapkey("n", "<C-Left>", ":vertical resize +2<CR>")
mapkey("n", "<C-Right>", ":vertical resize -2<CR>")

-- Buffer navigation
mapkey("n", "<S-TAB>", ":bprevious<CR>")
mapkey("n", "<TAB>", ":bnext<CR>")

-- Indent mode
mapkey("v", "<", "<gv")
mapkey("v", ">", ">gv")

-- Save file
mapkey("n", "<C-s>", ":w<CR>")

-- Paste without yank
mapkey("v", "p", '"_dP')

-- NERDCommenter
mapkey("n", "++", "<Plug>NERDCommenterToggle")
mapkey("v", "++", "<Plug>NERDCommenterToggle gv")

-- Alpha
mapkey("n", "<leader>m", ":Alpha <CR>")


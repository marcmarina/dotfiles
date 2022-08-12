-- Keymap helper
local function keymap(mode, key, action)
	vim.api.nvim_set_keymap(mode, key, action, {
		noremap = true,
		silent = true,
	})
end

-- Remap leader
keymap("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Split navigation
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

-- Explore
keymap("n", "<leader>e", ":NvimTreeFindFileToggle<CR>")

-- Telescope
keymap("n", "<leader>g", ":Telescope git_files<CR>")
keymap("n", "<leader>b", ":Telescope buffers<CR>")
keymap("n", "<leader>p", ":Telescope find_files<CR>")
keymap("n", "<leader>t", ":Telescope<CR>")

-- Resizing
keymap("n", "<C-Up>", ":resize +2<CR>")
keymap("n", "<C-Down>", ":resize -2<CR>")
keymap("n", "<C-Left>", ":vertical resize +2<CR>")
keymap("n", "<C-Right>", ":vertical resize -2<CR>")

-- Buffer navigation
keymap("n", "<S-h>", ":bnext<CR>")
keymap("n", "<S-l>", ":bprevious<CR>")

-- Indent mode
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Save file
keymap("n", "<C-s>", ":w<CR>")

-- Paste without yank
keymap("v", "p", '"_dP')

-- NERDCommenter
keymap("n", "++", "<Plug>NERDCommenterToggle")
keymap("v", "++", "<Plug>NERDCommenterToggle")

-- Alpha
keymap("n", "<leader>m", ":Alpha <CR>")


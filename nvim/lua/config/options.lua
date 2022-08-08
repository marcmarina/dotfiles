local options = {
  number = true,
  clipboard = "unnamedplus",
  mouse = "a",
  shiftwidth = 2,
  tabstop = 2,
	fileencoding = "utf-8",
	showmode = false,
	ignorecase = true,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- NERDCommenter
vim.cmd [[

let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'

]]


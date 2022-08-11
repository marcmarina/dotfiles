local options = {
  number = true,
  clipboard = "unnamedplus",
  mouse = "a",
  shiftwidth = 2,
  tabstop = 2,
	fileencoding = "utf-8",
	ignorecase = true,
	termguicolors = true,
	showmode = false,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end


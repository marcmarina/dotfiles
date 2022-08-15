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
  scrolloff = 2,
  hlsearch = true,                         -- highlight all matches on previous search pattern
  showtabline = 2,                         -- always show tabs
  smartcase = true,                        -- smart case
  smartindent = true,                      -- make indenting smarter again
  splitbelow = true,                       -- force all horizontal splits to go below current window
  splitright = true,                       -- force all vertical splits to go to the right of current window
  updatetime = 300,                        -- faster completion (4000ms default)
  cursorline = true,                       -- highlight the current line
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd [[

command! CopyFilePath :let @+ = expand("%") " Copy relative path to the current buffer

]]

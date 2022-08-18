require "config.options"
require "config.keymaps"
require "config.plugins"
require "config.colorscheme"
require "config.treesitter"
require "config.telescope"
require "config.alpha"
require "config.gitsigns"
require "config.coc"
require "config.project"
require "config.tree"
require "config.bufferline"
require "config.tagalong"

-- NERDCommenter
vim.g.NERDSpaceDelims = 1
vim.g.NERDDefaultAlign = 'left'

-- Airline
vim.g.airline_theme = 'bubblegum'

-- Vimscript
--
vim.cmd [[

" Auto toggle relative/normal line numbers
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

" Custom commands
command! CopyFilePath :let @+ = expand("%") " Copy relative path to the current buffer

cabbrev Git vert Git

" Filetypes
au BufEnter .zshrc setf sh

]]


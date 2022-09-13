local keymap = require("helpers.keymaps")

keymap("n", "<leader>.", "<Plug>(coc-codeaction)")
keymap("n", "<leader>l", ":CocCommand eslint.executeAutofix<CR>")
keymap("n", "gd", "<Plug>(coc-definition)")
keymap("n", "K", ":call CocActionAsync('doHover')<CR>")
keymap("n", "<F2>", "<Plug>(coc-rename)")

keymap("n", "gd", "<Plug>(coc-definition)")
keymap("n", "gy", "<Plug>(coc-type-definition)")
keymap("n", "gi", "<Plug>(coc-implementation)")
keymap("n", "gr", "<Plug>(coc-references)")

vim.cmd [[

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" ENTER to accept completion suggestion
inoremap <silent><expr> <cr> coc#pum#visible() && coc#pum#info()['index'] < 0 ? "\<CR>" :
        \ coc#pum#visible() && coc#pum#info()['index'] != -1 ? coc#pum#confirm() :
        \ "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"


" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" TAB and S-TAB to cycle through options
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Coc config
let g:coc_global_extensions = [
			\ 'coc-tsserver',
			\ 'coc-prettier',
			\ 'coc-pairs',
			\ 'coc-json',
			\ 'coc-docker',
			\ 'coc-eslint',
			\ 'coc-lua',
			\ ]

]]


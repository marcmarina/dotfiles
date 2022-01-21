call plug#begin('~/.vim/plugged')

" Workspace
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'editorconfig/editorconfig-vim'

" Appearance
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Coding
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdcommenter'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'chrisbra/csv.vim'
Plug 'mg979/vim-visual-multi'
Plug 'styled-components/vim-styled-components'
Plug 'jparise/vim-graphql'

call plug#end()


" Leader key
let g:mapleader=","

" Appearance
colorscheme gruvbox
let g:airline_theme = 'wombat'
set number

" Editor behaviour
set mouse=a
set tabstop=2
set shiftwidth=2

" Shortcutting split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Clipboard
set clipboard=unnamedplus

" CTRL-S to save
map <silent> <C-s> :w<CR>

" Clear highlights
noremap <silent> \\ :noh<return>


" Custom Commands
command! CopyFilename :let @+ = expand("%") " Copy relative path to the current buffer
command! -nargs=1 NewFile :e %:p:h/<args> " Create new file with given name in the current directory


" NERDCommenter
vmap ++ <plug>NERDCommenterToggle
nmap ++ <plug>NERDCommenterToggle
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'


" FZF Config
nnoremap <silent> <C-p> :Files!<CR>
nnoremap <silent> <C-g> :GFiles!<CR>
nnoremap <silent> <Leader>g :GFiles!?<CR>
nnoremap <silent> <C-b> :Buffers!<CR>
nnoremap <C-f> :Rg!<CR>


" Coc config
let g:coc_global_extensions = [
			\ 'coc-tsserver',
			\ 'coc-prettier',
			\ 'coc-pairs',
			\ 'coc-json',
			\ 'coc-docker',
			\ 'coc-eslint',
			\ ]

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Renaming
nmap <F2> <Plug>(coc-rename)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'vert h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction

command! -nargs=0 Prettier :CocCommand prettier.formatFile


" airline
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''

let g:airline#extensions#tabline#enabled = 1


" CSV
let g:csv_no_conceal=1


" Fugitive
command! -nargs=0 VG :vert Git

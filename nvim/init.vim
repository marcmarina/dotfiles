set runtimepath+=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

call plug#begin('~/.vim/plugged')

" Workspace
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'preservim/nerdtree'

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
set background=dark
let g:airline_theme = 'wombat'
set number
set ignorecase

" Editor behaviour
set mouse=a
set tabstop=2
set shiftwidth=2
set scrolloff=2

" Shortcutting split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Buffer navigation
nmap <silent> <S-h> :bnext<CR>
nmap <silent> <S-l> :bprevious<CR>

" Indenting
vmap <silent> < <gv
vmap <silent> > >gv

" Paste without yank
vmap <silent> p "_dP

set clipboard=unnamedplus

" CTRL-S to save
map <silent> <C-s> :w<CR>

" Clear highlights
noremap <silent> \\ :noh<return>

" Auto toggle relative/normal line numbers
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END


" Custom Commands
command! CopyFilePath :let @+ = expand("%") " Copy relative path to the current buffer
command! -nargs=1 NewFile :e %:p:h/<args> " Create new file with given name in the current directory
command! Source :so ~/.vimrc " Source configuration file


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
nnoremap <silent> <C-f> :Rg!<CR>
nnoremap <silent> <Leader>p :Commands!<CR>


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

" TAB and S-TAB to cycle through options
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" ENTER to accept completion suggestion
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Applying codeAction to the selected region.
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> <Leader>l :CocList<CR>

" Renaming
nmap <F2> <Plug>(coc-rename)

" Use gh to show documentation in preview window
nnoremap <silent> gh :call <SID>show_documentation()<CR>

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


" NERDTree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>


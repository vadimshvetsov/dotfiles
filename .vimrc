call plug#begin('~/.vim/plugged')

Plug 'dracula/vim', { 'as': 'dracula' } " Vim dracula color scheme - https://draculatheme.com/vim/

Plug 'scrooloose/nerdtree' " Show files tree on the left sider
Plug '/usr/local/opt/fzf' " Fuzzy finder, installed via brew with Ag
Plug 'junegunn/fzf.vim' " Extend work with fzf adding Ag
Plug 'scrooloose/nerdcommenter' " Comments functionality mappings
Plug 'vim-airline/vim-airline' " Draw a nice statusline at the bottom of each window 
Plug 'vim-airline/vim-airline-themes' " Statusline theme configuring possibility
Plug 'jiangmiao/auto-pairs' " Insert or delete brackets, parens, quotes in pair.
" Plug 'tpope/vim-surround' " Surround add, replace and delete
" Plug 'dyng/ctrlsf.vim' " Multiple file edit
" Plug 'terryma/vim-multiple-cursors' " Multiple cursor

" Plug 'w0rp/ale' " Asynchronous lint engine
" Plug 'SirVer/ultisnips' " Snippet engine
" Plug 'suan/vim-instant-markdown' " Markdown instant preview support
" Plug 'heavenshell/vim-jsdoc' " JSDoc support
" Plug 'rizzatti/dash.vim' " Dash support

" Format plugins
Plug 'mhinz/vim-mix-format'
" Plug 'prettier/vim-prettier', { 'do': 'npm install' }

" Syntax plugins

Plug 'pearofducks/ansible-vim'
Plug 'elixir-editors/vim-elixir' 
" Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
" Plug 'mxw/vim-jsx', { 'for': 'javascript' }
" Plug 'jparise/vim-graphql'
" Plug 'styled-components/vim-styled-components'
" Plug 'elzr/vim-json', { 'for': 'json' }
" Plug 'jxnblk/vim-mdx-js'

call plug#end()

set number

set smartindent
set tabstop=2
set shiftwidth=2

set hlsearch
set incsearch
set showmatch

set clipboard=unnamed " Yank to clipboard back and force
set splitright " Split right new buffer

" " Set undofile
set undodir=~/.vim/undodir
set undofile
set noswapfile

" Dracula theme
syntax on
let g:dracula_italic = 0 " Terminal doesn't support italic
colorscheme dracula
highlight Normal ctermbg=None " Use terminal background

" Map leader key
let mapleader = "\<Space>"

" File save/quit
nmap <silent> <leader>s :w<CR>
nmap <silent> <leader>q :q<CR>

" Format Elixir files on save
let g:mix_format_on_save = 1

" Edit .vimrc
map <silent> <leader>v :vsp $MYVIMRC<CR>
map <silent> <leader>V :source $MYVIMRC<CR>

" Remove highlight
nmap <silent> <leader><Esc> :nohls<CR>

" Find and replace
nnoremap <Leader>r :%s///g<Left><Left>

" Buffer
nmap <silent> <leader>w :bd<CR>
nmap <silent> <leader>b :Buffer<CR>
nmap <silent> <leader>bn :bn<CR>
nmap <silent> <leader>bp :bp<CR>
nmap <silent> <leader>k <C-w><Up>
nmap <silent> <leader>j <C-w><Down>
nmap <silent> <leader>l <C-w><Right>
nmap <silent> <leader>h <C-w><Left>

" NERDTree
let g:NERDTreeQuitOnOpen = 1

nmap <silent> <leader>i :NERDTreeFind<CR> " Open NERDTree in file directory

" NERDCommenter
let g:NERDSpaceDelims = 1

" FZF and AG settings
" Left rail background color issue https://github.com/junegunn/fzf/issues/1468
nmap <silent> <leader>f :FZF --color=bg+:-1<CR>
nmap <silent> <leader>a :Ag!<CR>
nnoremap <silent> <leader>A :Ag!<C-R><C-W><CR>
nnoremap <silent> <leader>F :call fzf#vim#files('.', {'options':'--color=bg+:-1 --query '.expand('<cword>')})<CR>

" Ag search only content not filenames
command! -bang -nargs=* Ag
	\ call fzf#vim#ag(<q-args>,
	\                 <bang>0 ? fzf#vim#with_preview({'options': '--color=bg+:-1 --delimiter : --nth 4..'}, 'up:60%')
	\                         : fzf#vim#with_preview({'options': '--color=bg+:-1 --delimeter : --nth 4..'}, 'right:50%:hidden', '?'),
	\                 <bang>0)

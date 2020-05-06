call plug#begin('~/.vim/plugged')

Plug 'dracula/vim', { 'as': 'dracula' } " Vim dracula color scheme - https://draculatheme.com/vim/

Plug 'scrooloose/nerdtree' " Show files tree on the left sider
Plug '/usr/local/opt/fzf' " Fuzzy finder, installed via brew with Ag


Plug 'junegunn/fzf.vim' " Extend work with fzf adding Ag
Plug 'scrooloose/nerdcommenter' " Comments functionality mappings
Plug 'vim-airline/vim-airline' " Draw a nice statusline at the bottom of each window 
Plug 'vim-airline/vim-airline-themes' " Statusline theme configuring possibility
Plug 'jiangmiao/auto-pairs' " Insert or delete brackets, parens, quotes in pair.
Plug 'tpope/vim-surround' " Surround add, replace and delete
" Plug 'SirVer/ultisnips' " Snippet engine

" Format plugins
Plug 'mhinz/vim-mix-format'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'sheerun/vim-polyglot'

" Language Server Client dependecies
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

call plug#end()

set number

set smartindent
set tabstop=2
set shiftwidth=2
set backspace=indent,eol,start " Use without limits

set hlsearch
set incsearch
set showmatch

set clipboard=unnamed " Yank to clipboard back and force
set splitright " Split right new buffer

" Set undofile
set undodir=~/.vim/undodir
set undofile
set noswapfile

" Set mouse
if has('mouse')
  set mouse=a
endif

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

" Airline tabs
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

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

" FZF existance workaround for installed fzf via apt-get
" https://github.com/junegunn/fzf.vim/issues/848#issuecomment-512777975
if !empty(glob("/usr/share/doc/fzf/examples/fzf.vim"))
	source /usr/share/doc/fzf/examples/fzf.vim
endif

" LSP

set updatetime=300 

let g:lsp_diagnostics_float_delay = 100
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_signs_error = {'text': '✗'}
let g:lsp_signs_warning = {'text': '!'}
let g:lsp_signs_information = {'text': '•'}
let g:lsp_signs_hint = {'text': '✐'}

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR> pumvisible() ? asyncomplete#close_popup() . "\<CR>" : "\<CR>"

nmap <silent> <leader>d :LspDefinition<CR>
nmap <silent> <leader>t :LspTypeDefinition<CR>
nmap <silent> <leader>h :LspHover<CR>

" Prettier works async (must be after LSP)
let g:prettier#exec_cmd_async = 1
let g:prettier#autoformat = 1
let g:prettier#autoformat_config_present = 1
let g:prettier#autoformat_require_pragma = 0


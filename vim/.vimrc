call plug#begin('~/.vim/plugged')

Plug 'dracula/vim', { 'as': 'dracula' } " Vim dracula color scheme - https://draculatheme.com/vim/

Plug 'scrooloose/nerdtree' " Show files tree on the left sider
Plug '/opt/homebrew/opt/fzf' " Fuzzy finder, installed via brew with Ag

Plug 'junegunn/fzf.vim' " Extend work with fzf adding Ag

Plug 'scrooloose/nerdcommenter' " Comments functionality mappings
Plug 'vim-airline/vim-airline' " Draw a nice statusline at the bottom of each window 
Plug 'vim-airline/vim-airline-themes' " Statusline theme configuring possibility
Plug 'jiangmiao/auto-pairs' " Insert or delete brackets, parens, quotes in pair.
Plug 'tpope/vim-endwise' " Autocomplete end after a do
Plug 'tpope/vim-surround' " Surround add, replace and delete
Plug 'weirongxu/plantuml-previewer.vim' " PlantUML editing with liveviewing
Plug 'tyru/open-browser.vim' " Open browser

" Format plugins
Plug 'mhinz/vim-mix-format'

" Syntax
Plug 'sheerun/vim-polyglot'
Plug 'aklt/plantuml-syntax'

" LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}


call plug#end()

set number " Show line numbers
set ruler " Show column number in statusline

set autoindent " Indent new line
set smartindent " Indent inside brackets

set tabstop=2
set shiftwidth=2
set expandtab " Default to spaces instead tabs
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

" Faster redrawing
set ttyfast
set updatetime=300

" Faster moving from visual to normal on escape
set timeoutlen=1000 ttimeoutlen=0

" Set mouse
if has('mouse')
  set mouse=a
endif

" Dracula theme
syntax on
" Add useage for italic
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

colorscheme dracula
highlight Normal ctermbg=None " Use terminal background

" Map leader key
let mapleader = "\<Space>"

" File save/quit
nmap <silent> <leader>s :w<CR>
nmap <silent> <leader>q :q<CR>
" File save without coc-nvim autoformatting
nmap <silent> <leader>S :noa w<CR>

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
" Highlighting comments in JSON
autocmd FileType json syntax match Comment +\/\/.\+$+

" FZF and AG settings
" Left rail background color issue https://github.com/junegunn/fzf/issues/1468
let g:fzf_preview_window = ['up:70%', 'ctrl-/']
let g:fzf_layout = { 'window': { 'width': 1, 'height': 1 } }
let $FZF_DEFAULT_OPTS .= ' --color=bg+:-1'
let $FZF_DEFAULT_COMMAND = 'ag -g ""'

" nmap <silent> <leader>f :FZF!<CR>
nmap <silent> <leader>f :call fzf#vim#files('.', fzf#vim#with_preview(), 1)<CR>
nmap <silent> <leader>a :Ag!<CR>
nnoremap <silent> <leader>A :Ag!<C-R><C-W><CR>
nnoremap <silent> <leader>F :call fzf#vim#files('.', fzf#vim#with_preview({'options':' --query '.expand('<cword>')}), 1)<CR>

" Ag search only content not filenames
command! -bang -nargs=* Ag
	\ call fzf#vim#ag(<q-args>, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

" FZF existance workaround for installed fzf via apt-get
" https://github.com/junegunn/fzf.vim/issues/848#issuecomment-512777975
if !empty(glob("/usr/share/doc/fzf/examples/fzf.vim"))
	source /usr/share/doc/fzf/examples/fzf.vim
endif

" LSP (Most of settings from docs)

set cmdheight=2 " More space for messages
set signcolumn=yes " Prevent shifting
set hidden

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use d to show documentation in preview window.
nnoremap <silent> <leader>d :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" CoC extensions
let g:coc_global_extensions = ['coc-elixir', 'coc-tsserver', 'coc-json', 'coc-eslint', 'coc-prettier', 'coc-yaml', 'coc-styled-components']

" CoC Prettier
command! -nargs=0 Prettier :call CocActionAsync('runCommand', 'prettier.formatFile')
nmap <silent> <leader>p :Prettier<CR>

" Format Elixir files on save
let g:mix_format_on_save = 1


" Use completion
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Insert <tab> when previous text is space, refresh completion if not.
inoremap <silent><expr> <TAB>
\ coc#pum#visible() ? coc#pum#next(1):
\ <SID>check_back_space() ? "\<Tab>" :
\ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif
 
inoremap <expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<CR>"

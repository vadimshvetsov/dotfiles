set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
[ -f $HOME/.vimrc ] && source $HOME/.vimrc

call plug#begin('~/.local/share/nvim/plugged')

Plug 'dracula/vim', { 'as': 'dracula' } " Vim dracula color scheme - https://draculatheme.com/vim/
Plug 'scrooloose/nerdtree' " Show files tree on the left sider
Plug 'scrooloose/nerdcommenter' " Commenter
Plug 'vim-airline/vim-airline' " Draw a nice statusline at the bottom of each window 
Plug 'vim-airline/vim-airline-themes' " Statusline theme configuring possibility
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Fuzzy finder
Plug 'junegunn/fzf.vim' " Extend work with fzf
Plug 'dyng/ctrlsf.vim' " Multiple file edit
Plug 'tpope/vim-fugitive' " Git wrapper
Plug 'ryanoasis/vim-devicons' " Show icons for filetypes at NERDTree
Plug 'tpope/vim-surround' " Surround add, replace and delete
Plug 'terryma/vim-multiple-cursors' " Multiple cursor
Plug 'jiangmiao/auto-pairs' " Insert or delete brackets, parens, quotes in pair.
Plug 'w0rp/ale' " Asynchronous lint engine
Plug 'SirVer/ultisnips' " Snippet engine

" Syntax plugins

Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'mxw/vim-jsx', { 'for': 'javascript' }
Plug 'jparise/vim-graphql', { 'for': 'javascript' }
Plug 'styled-components/vim-styled-components'
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'pearofducks/ansible-vim'

call plug#end()

" Standart settings
set number
set showmatch 
set hlsearch
set incsearch
set smartindent
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set noswapfile
set splitright
set clipboard=unnamed

" Set mouse
if has('mouse')
  set mouse=a
endif

" Forbid overriding syntax items on re-sourcing
if !exists('g:syntax_on')
	syntax enable
endif

" Theme
color dracula
let g:airline_theme='dracula'

" Map leader key
let mapleader = "\<Space>"

" File save/quit
nmap <silent> <C-s> :w<CR>
nmap <silent> <leader>q :q<CR>

" Edit .vimrc
map <silent> <leader>v :vsp $MYVIMRC<CR>
map <silent> <leader>V :source $MYVIMRC<CR>

" Remove highlight
nmap <silent> <leader><Esc> :nohls<CR>

" Multiple cursors
let g:multi_cursor_select_all_word_key = '<C-a>'

" Find and replace
nnoremap <Leader>r :%s///g<Left><Left>

" Buffer
nmap <silent> <leader>w :bd<CR>
nmap <silent> <leader>b :Buffer<CR>
nmap <C-k> <C-w><Up>
nmap <C-j> <C-w><Down>
nmap <C-l> <C-w><Right>
nmap <C-h> <C-w><Left>

" NERDCommenter
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'

" NERDTree
let g:NERDTreeQuitOnOpen = 1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif " Close vim if the only open is a NERDTree
nmap <silent> <C-i> :NERDTreeFind<CR> " Open NERDTree in file directory
nmap <silent> <leader><leader> :NERDTreeToggle<CR> " Toggle NERDTree

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

" FZF and AG settings
nmap <silent> <leader>f :FZF<CR>
nmap <silent> <leader>a :Ag!<CR>
nnoremap <silent> <leader>A :exe 'Ag!' expand('<cword>')<CR>
nnoremap <silent> <leader>F :call fzf#vim#files('.', {'options':'--query '.expand('<cword>')})<CR>

" Ag search only content not filenames
" https://github.com/junegunn/fzf.vim/issues/346#issuecomment-288483704
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)

" Ag search preview
" command! -bang -nargs=* Ag
"   \ call fzf#vim#ag(<q-args>,
"   \                 <bang>0 ? fzf#vim#with_preview('up:60%')
"   \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
"   \                 <bang>0)

" CtrlSF settings
nmap <silent> <leader>s <Plug>CtrlSFPrompt<CR>
vmap <silent> <leader>S <Plug>CtrlSFVwordExec<CR>

" Ale lint
nmap <silent> <leader>n <Plug>(ale_next_wrap)
nmap <silent> <leader>N <Plug>(ale_previous_wrap)
nmap <silent> <leader>l <Plug>(ale_fix)

let g:ale_fix_on_save = 1
let g:ale_linters = {
  \ 'javascrtipt': ['eslint'],
  \}
let g:ale_fixers = {
  \ 'javascript': ['eslint'],
  \}

" JSON highlight
let g:vim_json_syntax_conceal = 0
hi! def link jsonKeyword Identifier
au BufRead,BufNewFile {.babelrc,.eslintrc} set ft=json

" Git
nmap <silent> <leader>gs :Gstatus<CR>
nmap <silent> <leader>gb :Gblame<CR>
nmap <silent> <leader>gr :Gread<CR>
nmap <silent> <leader>gd :Gdiff<CR>

" Devicons
let g:WebDevIconsOS = 'Darwin'
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1

" UltiSnips configuration
nmap <silent> <leader>u :UltiSnipsEdit<CR>

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetsDir="~/.vim/UltiSnips"

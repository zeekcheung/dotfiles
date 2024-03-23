" --------------------------------------------
" ----------------- options ------------------
" --------------------------------------------
let mapleader=" "
let maplocalleader=" "

" backup/swap/undo
set nobackup
set nowritebackup
set noswapfile
set undodir=~/.vim/undodir
set undolevels=10000

" number line
set number
set relativenumber

" indent
set shiftwidth=2
set tabstop=2
set expandtab
set autoindent
set smartindent
set shiftround

" search
set hlsearch
set ignorecase
set smartcase
set incsearch

" scroll
set scrolloff=5
set sidescrolloff=8

" split
set splitbelow
set splitright
set splitkeep=screen

" vertical wildmenu
set wildmenu
set wildoptions=pum
set wildignorecase

" completion
set completeopt="menu,menuone,noinsert"
set pumheight=10

" chars
set fillchars=eob:\ ,fold:\ ,vert:\|
" set listchars=tab:▸\ ,eol:¬

" miscellaneous
set cursorline
set showmatch
set laststatus=2
set mouse=a
set clipboard=unnamedplus
set autowrite
set encoding=utf-8
set ttyfast
set timeoutlen=300

" netrw
let g:netrw_winsize=25
let g:netrw_banner=0
let g:netrw_liststyle=3

colorscheme sorbet

function! DrawMyColors()
  hi StatusLine ctermbg=black guibg=black
endfunction

" --------------------------------------------
" ----------------- keymaps ------------------
" --------------------------------------------

" Better escape
inoremap <silent> jj <esc>

" Better indenting
vnoremap <silent> < <gv
vnoremap <silent> > >gv

" Buffers
nnoremap <silent> <Tab> :bp<cr>
nnoremap <silent> <S-Tab> :bn<cr>
nnoremap <silent> <leader>bd :bd!<cr>
nnoremap <silent> <leader>x :x!<cr>

" Copy/Cut
vnoremap <silent> <C-c> "+y
vnoremap <silent> <C-x> "+d

" Move between windows
nnoremap <silent> <C-l> :<C-u>echo<CR>

nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

" Resize window using <ctrl> arrow keys
nnorema <silent> <C-Up> :resize +2<cr>
nnorema <silent> <C-Down> :resize -2<cr>
nnorema <silent> <C-Left> :vertical resize -2<cr>
nnorema <silent> <C-Right> :vertical resize +2<cr>

" Clear search with <esc>
nnoremap <silent> <esc> <esc>:noh<cr><esc>
inoremap <silent> <esc> <esc>:noh<cr><esc>

" Move lines
" Hack: terminal emulator will send Esc when pressing Alt in vim
" execute "set <A-j>=\ej" 
" execute "set <A-k>=\ek"
" nnoremap <A-j> :m+<CR>
" inoremap <A-j> <Esc>:m+<CR>i
" vnoremap <A-j> :m+<CR>gv=gv
" nnoremap <A-k> :m-2<CR>
" inoremap <A-k> <Esc>:m-2<CR>i
" vnoremap <A-k> :m-2<CR>gv=gv

" Quit
nnoremap <silent> <leader>qq :qa!<cr>

" Save file
nnoremap <silent> <C-s> <esc>:w!<cr><esc>
xnoremap <silent> <C-s> <esc>:w!<cr><esc>
snoremap <silent> <C-s> <esc>:w!<cr><esc>
inoremap <silent> <C-s> <esc>:w!<cr><esc>

" Select all
nnoremap <silent> <C-a> <esc>ggVG
vnoremap <silent> <C-a> <esc>ggVG
xnoremap <silent> <C-a> <esc>ggVG
inoremap <silent> <C-a> <esc>ggVG

" Split window
nnoremap <silent> \| :split<cr>
nnoremap <silent> \ :vsplit<cr>

" Toggle netrw
nnoremap <silent> <leader>e :Lexplore<cr>

" Undo
nnoremap <silent> <C-z> :undo<cr>
inoremap <silent> <C-z> <esc>:undo<cr>

" --------------------------------------------
" ----------------- autocmds -----------------
" --------------------------------------------

augroup MyColors
  autocmd!
  autocmd ColorScheme * call DrawMyColors()
augroup END

" Jump to last edit position when opening files
silent! source $VIMRUNTIME/defaults.vim

" Check if we need to reload the file when it changed
autocmd FocusGained * checktime

" Resize splits if window is resized
autocmd VimResized * :wincmd =

" Change indent size for different filetypes
autocmd Filetype c,cpp,h,hpp,python setlocal shiftwidth=4 tabstop=4

" Netrw 
augroup NetrwCustomKeymaps
    autocmd FileType netrw {
      nnoremap <buffer> <silent> <C-l> <C-w>l
    }
augroup END

augroup AutoDeleteNetrwHiddenBuffers
  au!
  au FileType netrw setlocal bufhidden=wipe
augroup end


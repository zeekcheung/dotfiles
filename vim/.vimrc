" --------------------------------------------
" ----------------- options ------------------
" --------------------------------------------
let mapleader=" "                      " Set mapleader to space key
let maplocalleader=" "                 " Set maplocalleader to space key

set autoindent                           " Enable auto-indentation
set autowrite                            " Automatically save modified files
set background=dark                      " Set background to dark colorscheme
set backupdir=~/.vim/backup              " Set backup directory
set clipboard=unnamedplus                " Sync with system clipboard
" set confirm                            " Confirm to save changes before exiting modified buffer
set completeopt="menu,menuone,noinsert"  " Set options for completion menu
set conceallevel=2
set cursorline                           " Highlighting current line
set directory=~/.vim/swap                " Set swap directory
set expandtab                            " Use spaces instead of tabs
set encoding=utf-8                       " Set encoding to UTF-8
set fillchars=eob:\ ,fold:\ ,vert:\|
set hlsearch                             " Highlight search results
set ignorecase                           " Ignore case when searching
set incsearch                            " Show search matches incrementally
set laststatus=2                         " Show status line
set listchars=tab:▸\ ,eol:¬              " Set visible characters for tabs and end of line
set mouse=a                              " Enable mouse support
set nobackup                             " Disable backup file
set nocompatible                         " Disable compatibility mode
set noerrorbells                         " Disable error bells
set nolist                               " Disable list mode
set noswapfile                           " Enable swap files
set noundofile                           " Disable persistent undo
set nowritebackup                        " Disable write back up
set number                               " Show line numbers
set pumheight=10
set relativenumber                       " Show relative line numbers
set scrolloff=5                          " Keep 5 lines of context while scrolling
set shiftround                           " Indent by multiples of shiftwidth
set shiftwidth=2                         " Set indent width to 2 spaces
set showcmd                              " Show current command being typed
set showmatch                            " Highlight matching parentheses
set noshowmode                           " Show current mode
set sidescrolloff=8
set splitbelow
set splitkeep=screen
set splitright
set smartcase                            " Use smart case when searching
set smartindent
set t_Co=256                             " Set terminal colors to 256 colors
set tabstop=2                            " Set tab width to 2 spaces
set termguicolors                        " Use terminal colors
set timeoutlen=300                       " Set timeout length for mappings
set ttyfast                              " Improve responsiveness in terminal
set undodir=~/.vim/undodir               " Set undo directory
set undolevels=10000                     " Increase maximum number of undos
set updatetime=200                       " Set time interval for updating changes
set vb t_vb=                             " Disable visual bells
set wildmode=longest:full,full
set wildignorecase                       " Ignore case in wildmenu
set winminwidth=5                        " Set minimum window width to 5 columns

let g:colorscheme="habamax"
let g:transparent_background=2

" Netrw
let g:netrw_banner=0
let g:netrw_winsize=25
let g:netrw_liststyle=3

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
nnoremap <silent> <C-c> "+y
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
nnoremap <A-k> :m-2<CR>
inoremap <A-k> <Esc>:m-2<CR>i
vnoremap <A-k> :m-2<CR>gv=gv
 
nnoremap <A-j> :m+<CR>
inoremap <A-j> <Esc>:m+<CR>i
vnoremap <A-j> :m+<CR>gv=gv

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

" Toggle Netrw
nnoremap <silent> <leader>e :Lexplore<cr>

" Undo
nnoremap <silent> <C-z> :undo<cr>
inoremap <silent> <C-z> <esc>:undo<cr>

" Git
nnoremap <silent> <leader>gg :FloatermNew lazygit<cr>

" --------------------------------------------
" ----------------- autocmds -----------------
" --------------------------------------------

" Netrw 
augroup NetrwCustomKeymaps
    autocmd FileType netrw {
      nnoremap <buffer> <silent> <C-l> <C-w>l
    }
augroup END


" Netrw
augroup AutoDeleteNetrwHiddenBuffers
  au!
  au FileType netrw setlocal bufhidden=wipe
augroup end

" Setup colorscheme and custom highlighting
function! CustomHighlight()
  if g:transparent_background
    exe 'hi! Normal guibg=NONE ctermbg=NONE'
  endif
  exe 'hi! link NormalFloat Normal'
  exe 'hi! link FloatBorder Normal'
  exe 'hi! link LspInfoBorder Normal'
endfunction

autocmd VimEnter * nested
  \ exe 'colorscheme ' . g:colorscheme
  \ | call CustomHighlight()

autocmd ColorScheme * call CustomHighlight()

" Check if we need to reload the file when it changed
autocmd FocusGained * checktime

" Resize splits if window is resized
autocmd VimResized * :wincmd =

" Change indent size for different filetypes
autocmd Filetype c,cpp,h,hpp,python setlocal shiftwidth=4 tabstop=4

" Disable conceal in json files
autocmd Filetype json,jsonc,json5 setlocal conceallevel=0

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

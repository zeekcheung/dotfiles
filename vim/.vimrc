" --------------------------------------------
" ----------------- options ------------------
" --------------------------------------------
let mapleader=" "
let maplocalleader=" "

" backup/swap/undo
set nobackup
set nowritebackup
set noswapfile
set undofile
set undolevels=10000
set undodir=~/.vim/undodir
if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
endif

" number line
set number
set relativenumber

" indent
set shiftwidth=4
set tabstop=4
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
set listchars=tab:▸\ ,eol:¬

" cursor shape
let &t_SI.="\e[5 q"
let &t_SR.="\e[4 q"
let &t_EI.="\e[1 q"

" miscellaneous
set cursorline
set showmatch
set laststatus=0
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
nnoremap <silent> <leader>qw :close<cr>

" Save file
nnoremap <silent> <C-s> <esc>:w!<cr><esc>
xnoremap <silent> <C-s> <esc>:w!<cr><esc>
snoremap <silent> <C-s> <esc>:w!<cr><esc>
inoremap <silent> <C-s> <esc>:w!<cr><esc>

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

" Colorscheme
let colorscheme="sorbet"
if findfile("colors/" .colorscheme .".vim", &rtp) != ""
    execute "colorscheme " . colorscheme
    hi! StatusLine ctermfg=104 ctermbg=NONE guifg=#888888 guibg=NONE 
    hi! StatusLineNC cterm=NONE ctermbg=NONE gui=NONE guibg=NONE
    hi! Visual cterm=NONE ctermbg=105 ctermfg=16 guibg=White guifg=Yellow
    hi! Pmenu ctermbg=NONE
    hi! PmenuSel ctermbg=105
else
    function! DrawMyColors()
        hi! StatusLine ctermbg=NONE guibg=NONE
        hi! StatusLineNC cterm=NONE ctermbg=NONE gui=NONE guibg=NONE
        hi! CursorLine cterm=NONE ctermbg=237 guibg=#363841
        hi! CursorLineNr cterm=NONE
        hi! LineNr term=underline ctermfg=7 guifg=lightgrey
    endfunction

    call DrawMyColors()
    augroup MyColors
        autocmd!
        autocmd ColorScheme * call DrawMyColors()
    augroup END
endif


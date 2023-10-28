" Bootstrap vim-plug
let data_dir = '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Set up plugins
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
call plug#begin()

nnoremap <silent> <leader>pc :PlugClean<cr>
nnoremap <silent> <leader>pi :PlugInstall<cr>
nnoremap <silent> <leader>pd :PlugDiff<cr>
nnoremap <silent> <leader>ps :PlugSnapshot<cr>
nnoremap <silent> <leader>pt :PlugStatus<cr>
nnoremap <silent> <leader>pu :PlugUpdate<cr>
nnoremap <silent> <leader>pg :PlugUpgrade<cr>

Plug 'ryanoasis/vim-devicons'

" Make sure you use single quotes
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
nnoremap <silent> <leader>e :NERDTreeToggle<cr>
let g:NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

Plug 'easymotion/vim-easymotion'
let g:EasyMotion_smartcase = 1
map <leader> <Plug>(easymotion-prefix)
map s <Plug>(easymotion-bd-f)
nmap s <Plug>(easymotion-overwin-f)

Plug 'liuchengxu/vim-which-key'
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

Plug 'voldikss/vim-floaterm'
let g:floaterm_autoinsert = v:true
let g:floaterm_autoclose = 2
let g:floaterm_width = 0.8
let g:floaterm_height = 0.8
nnoremap <silent> <leader>tf :FloatermNew<CR>
tnoremap <silent> <leader>tf <C-\><C-n>:FloatermNew<CR>
nnoremap <silent> <leader>tp :FloatermPrev<CR>
tnoremap <silent> <leader>tp <C-\><C-n>:FloatermPrev<CR>
nnoremap <silent> <leader>tn :FloatermNext<CR>
tnoremap <silent> <leader>tn <C-\><C-n>:FloatermNext<CR>
nnoremap <silent> <F7> :FloatermToggle<CR>
tnoremap <silent> <F7> <C-\><C-n>:FloatermToggle<CR>

Plug 'morhetz/gruvbox'
let g:gruvbox_contrast_dark = 'hard'

Plug 'catppuccin/vim', { 'as': 'catppuccin' }

" Plug 'Exafunction/codeium.vim', { 'branch': 'main' }
" imap <script><silent><nowait><expr> <C-g> codeium#Accept()
" imap <C-.>   <Cmd>call codeium#CycleCompletions(1)<CR>
" imap <C-,>   <Cmd>call codeium#CycleCompletions(-1)<CR>
" imap <C-x>   <Cmd>call codeium#Clear()<CR>

Plug 'tpope/vim-commentary'

" Use release branch (recommended)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_config_home = '~/.config/vim/coc'
let g:coc_data_home = '~/.config/vim/coc'

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
" You can revert the settings after the call like so:
" filetype indent off   " Disable file-type-specific indentation
" syntax off            " Disable syntax highlighting

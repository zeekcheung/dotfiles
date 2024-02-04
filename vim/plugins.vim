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

" file explorer
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
nnoremap <silent> <leader>e :NERDTreeToggle<cr>
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrowCollapsible = ''
let g:NERDTreeDirArrowExpandable = ''

" status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" quick jump
Plug 'easymotion/vim-easymotion'
let g:EasyMotion_smartcase = 1
map <leader> <Plug>(easymotion-prefix)
map s <Plug>(easymotion-bd-f)
nmap s <Plug>(easymotion-overwin-f)

" keymaps popup
Plug 'liuchengxu/vim-which-key'
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

" terminal
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

" colorschemes
Plug 'morhetz/gruvbox'
let g:gruvbox_contrast_dark = 'hard'

Plug 'sainnhe/gruvbox-material'
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_foreground = 'material'
let g:gruvbox_material_enable_bold = 1
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_dim_inactive_windows = 0
let g:gruvbox_material_menu_selection_background = 'green'
let g:gruvbox_material_show_eob = 0
let g:gruvbox_material_diagnostic_text_highlight = 1
let g:gruvbox_material_diagnostic_line_highlight = 1
let g:gruvbox_material_diagnostic_virtual_text = 'colored'
let g:gruvbox_material_statusline_style = 'mix'
let g:gruvbox_material_ui_contrast = 'high'
let g:gruvbox_material_transparent_background = g:transparent_background

Plug 'sainnhe/everforest'
let g:everforest_background = 'hard'
let g:everforest_foreground = 'material'
let g:everforest_enable_bold = 1
let g:everforest_enable_italic = 1
let g:everforest_dim_inactive_windows = 0
let g:everforest_menu_selection_background = 'green'
let g:everforest_show_eob = 0
let g:everforest_diagnostic_text_highlight = 1
let g:everforest_diagnostic_line_highlight = 1
let g:everforest_diagnostic_virtual_text = 'colored'
let g:everforest_statusline_style = 'mix'
let g:everforest_ui_contrast = 'high'
let g:everforest_transparent_background = g:transparent_background

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
let g:coc_node_path = '~/.nvm/versions/node/v20.11.0/bin/node'

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
" You can revert the settings after the call like so:
" filetype indent off   " Disable file-type-specific indentation
" syntax off            " Disable syntax highlighting

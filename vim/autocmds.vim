function! CustomHighlight()
  exe 'hi! link NormalFloat Normal'
  exe 'hi! link FloatBorder Normal'
  exe 'hi! link LspInfoBorder Normal'
endfunction

" Setup colorscheme and custom highlighting
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

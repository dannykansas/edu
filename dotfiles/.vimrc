" set modern tab widths and softabstop
set tabstop=2
set softtabstop=2 
set shiftwidth=2
set expandtab

syntax on

" Highlight lines over 80 columns wide (good for haskell and python)
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

" Required for vim-instant-markdown 
" https://github.com/suan/vim-instant-markdown
"filetype plugin on

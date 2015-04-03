
" Tab settings
set shiftwidth=2        " Tab spacing of 2 columns
set softtabstop=2       " unify
set shiftround          " round to nearest tab
set expandtab           " expand tabs to spaces

set cindent		
" smart indentation

" Dynamic incremental searching
set incsearch hlsearch
syntax on

" Obligatory
set nu

" Do Java autocomplete
autocmd Filetype java setlocal omnifunc=javacomplete#Complete



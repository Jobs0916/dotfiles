
let  s:plugin_dir = '~/.vim/plugged'
" Temporal
call plug#begin(s:plugin_dir)
    Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'npm ci'}
    Plug 'vim-airline/vim-airline'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'Yggdroot/indentLine'
    Plug 'luochen1990/rainbow'
    Plug 'mhinz/vim-startify'
    Plug 'mhinz/vim-signify'
    Plug 'preservim/tagbar'   
    Plug 'bfrg/vim-cpp-modern'
    Plug 'tpope/vim-surround'     " Surround ysw o cstt para cambiar las etiquetas por otras etiquetas
    Plug 'tpope/vim-commentary'   " For comment gcc & gc
    Plug 'alvan/vim-closetag'
    Plug 'Asheq/close-buffers.vim'
    Plug 'airblade/vim-gitgutter'
    Plug 'ghifarit53/tokyonight-vim'
    Plug 'drsooch/gruber-darker-vim'
    Plug 'junegunn/fzf'          
    Plug 'junegunn/fzf.vim'       " instalar fzf
    Plug 'mattn/emmet-vim'
    Plug 'NoahTheDuke/vim-just'
    
    "Pluggins de Ada
    Plug 'thindil/A.vim'
    Plug 'thindil/AdaBundle'

    " Colección completa para Pascal
    Plug 'mattia72/vim-delphi'
    Plug 'vim-scripts/fpc.vim'
    Plug 'skywind3000/asyncrun.vim'  " Para compilación asíncrona

call plug#end()



" Estructura de Tony (canal de youtube) para gestion de pluggins
" function! s:ensure(repo)
"     let name = split(a:repo,'/')[-1]
"     let path = s:plugin_dir . '/' . name

"     if !isdirectory(path)
"         if !isdirectory(s:plugin_dir,'p')
"         endif
"         execute '!git clone --depth=1 https://github.com/' . a:repo . ' ' .shellescape(path)
"     endif
"     execute 'set runtimepath+=' . fnameescape(path)
" endfunction

" call s:ensure('vim-airline/vim-airline')

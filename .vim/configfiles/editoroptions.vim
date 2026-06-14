" Senalizador de sintasys
syntax on
filetype indent plugin on

" Sintaxis de esquema de colores
set colorcolumn=80
set background=dark   

set termguicolors
let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1
colorscheme tokyonight

" colorscheme  PaperColor " Antiguo esquema de colores
highlight Pmenu ctermbg=8 ctermfg=0
highlight Pmenusel ctermbg=15 ctermfg=0

" Opciones de busqueda de carpeta y archivos swap
set directory=$HOME/.vim/swap//
set wildignore+=*/node_modules/*,*/.git/*,*/vendor/*,

"Configuracion basica
set belloff=all
packloadall
set cursorline

"Configuracion de los archivos 
set encoding=utf-8
scriptencoding utf-8
set backspace=indent,eol,start
set hidden

"Configuracion de los archivos de respaldos 
set undodir=~\vimfiles\undodir
set undofile
set noswapfile
set nobackup

" Opciones de busqueda
set hlsearch
set incsearch

set noshowmode
set laststatus=2
set wildmenu
set wildoptions=pum
set number
set relativenumber
set ruler
set showmatch
set mouse=a
set clipboard=unnamed

set smartindent
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set autoindent
set ignorecase       "Ignora las mayusculas en las busquedas

" Opciones para gvim activar y desactivar las barras de navegacion  ( gvim )
" set guioptions-=T
" set guioptions-=r
" set guioptions-=L
" set guioptions-=m
set scrolloff=8
set nowrap
" set cmdheight=2

" Modo del cursor en la terminal
let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"

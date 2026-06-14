
augroup filetypedetect
    autocmd BufNewFile,BufRead *.js
            \set smartindent
            \set expandtab
            \set shiftwidth=12
            \set tabstop=12
            \set softtabstop=12
augroup END

augroup filetypedetect
    autocmd BufNewFile,BufRead *.py,*.pyx
            \set smartindent
            \set expandtab
            \set shiftwidth=4
            \set tabstop=4
            \set softtabstop=4
augroup END
nnoremap <silent> <C-q> :Bdelete menu:<:<nop> <nop> <nop> <nop> <nop> <nop> cr>

" Validar como se usa correctamente
"autocmd FileType html set 
"omnifunc=htmlcomplete#CompleteTags

" Comando para formatear cualquier pagina
" gg=G


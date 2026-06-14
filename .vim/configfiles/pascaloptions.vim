" Detectar automáticamente archivos .pas como Pascal
let filetype_p = "pascal"
let filetype_pp = "pascal"

" Activar características de Free Pascal
let pascal_fpc = 1
let pascal_delphi = 1  " para keywords modernos

" Configurar compilador
autocmd FileType pascal compiler fpc

" Mapeo rápido para compilar
" nnoremap <F9> :make<CR>

" Mejorar indentación (si usas vim-delphi)
let g:delphi_build_config = 'Debug'


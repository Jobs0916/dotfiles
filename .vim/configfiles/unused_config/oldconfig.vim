let g:nnn#set_default_mappings = 0
let g:ale_completion_enabled = 1
let c_no_curly_error=1
" Show QuickUi menus tooltips
let g:quickui_show_tip = 1
" Set QuickUi menus theme to papercolor dark   'papercol dark'  "solarized light'
let g:quickui_color_scheme =  'papercol dark'
" Set QuickUi menus border style
let g:quickui_border_style = 2

if has("gui_running")
   " Muestra y esconde el menu con la tecla F7
   nnoremap <F7> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>
endif

" close tags configuration

" :CloseTagToggleBuffer
" :CloseTagEnableBuffer
" :CloseTagDisableBuffer
" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.

let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.vue,*.blade'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.vue,*.blade'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
"
let g:closetag_filetypes = 'html,xhtml,phtml,vue,blade'

" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filetypes = 'xhtml,jsx,vue,blade'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
"
let g:closetag_emptyTags_caseSensitive = 1

" dict
" Disables auto-close if not in a "valid" region (based on filetype)
"
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ 'typescriptreact': 'jsxRegion,tsxRegion',
    \ 'javascriptreact': 'jsxRegion',
    \ }

" Shortcut for closing tags, default is '>'
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
let g:closetag_close_shortcut = '<leader>>'

let g:closetag_enable_react_fragment = 1
" Disable closing tags for React fragments -> <></> for all supported file types

let g:closetag_enable_react_fragment = 0

" nnoremap all ggVG    " Para trabajar con scheme

" map <F4> :Lex! <bar> vertical resize 60 <CR>
"Se puede abreviar    vert     bot      term
"o
" nnoremap <F5> :wa <CR> :vert bot term ++kill=term<CR> 
" nnoremap <silent><F4> :wa \| vertical botright term ++kill=term<CR>   "
" Ultima version antes de usar F4

"set guifont=*				#Descomentar y hacer source para mostrar interfaz de fuentes
"Variables de entorno
"Tecla leader
let mapleader=" "

let $RTP=split(&runtimepath,',')[0]
if has('gui_gtk2') || has('gui_gtk3')
    let $RC="$HOME/.vimrc"
    set guifont=JetBrainsMono\ Nerd\ Font\ Mono\ 13
else
    let $RC="$HOME/_vimrc"
    set guifont=JetBrainsMono\ NFM:h14

    " Configuracion de GUI font de window 
    " set guifont=Consolas:h11:cANSI
    " set guifont=DejaVu\ Sans\ Mono:h12
    
    "Para entrar en modo full screen automaticamente en window 10
    " autocmd  GUIEnter * simalt ~x
endif

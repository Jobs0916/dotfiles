-- Opciones base de Neovim.
-- `vim.g.mapleader` se define en init.lua antes de cargar cualquier módulo.

-- Portapapeles del sistema
vim.o.clipboard = "unnamedplus"

-- Ajustes básicos
vim.o.number = true -- Línea vertical numérica
vim.o.relativenumber = true -- Línea vertical numérica relativa
vim.o.cursorline = true -- Marca la línea donde está el cursor
vim.o.scrolloff = 10 -- Muestra 10 líneas arriba y abajo del cursor
vim.o.sidescrolloff = 8 -- Muestra 8 líneas a la derecha e izquierda del cursor
vim.o.wrap = false -- No dobla las líneas cuando se pasa del límite de la pantalla

-- Indentación
vim.o.tabstop = 4 -- Ancho de la tabulación
vim.o.shiftwidth = 4 -- Ancho de la tabulación
vim.o.softtabstop = 4 -- Ancho de la tabulación suave
vim.o.expandtab = true -- Usa espacios en vez de tabs
vim.o.smartindent = true -- Autoindentado inteligente
vim.o.autoindent = true -- Copia el indentado desde la línea actual
vim.o.breakindent = true

-- Ajustes de búsqueda
vim.o.ignorecase = true -- Búsqueda insensitiva
vim.o.smartcase = true -- Búsqueda insensitiva si hay mayúscula en la búsqueda
vim.o.hlsearch = true -- No mostrar los resultados señalizados
vim.o.incsearch = true -- Muestra resultado mientras tecleas

-- Ajustes visuales
vim.o.winborder = "rounded" -- Activa bordes de las ventanas flotantes
vim.o.termguicolors = true -- Habilita los 24-bit de colores
vim.o.signcolumn = "yes" -- Muestra siempre la columna de símbolos
vim.o.showmatch = true -- Muestra las llaves, paréntesis y corchetes de cierre
vim.o.cmdheight = 1 -- Altura de la línea de comandos
vim.o.completeopt = "menuone,noinsert,noselect" -- Opciones de completado
vim.o.colorcolumn = "100" -- Muestra una línea vertical a los 100 caracteres
vim.o.showmode = false -- No muestra los modos en la línea de comandos
vim.o.pumheight = 10 -- Altura de 10 de la ventana pum del menú
vim.o.pumblend = 10 -- Transparencia del pum en 10
vim.o.winblend = 0 -- Pone flotante la ventana transparente
vim.o.conceallevel = 0 -- No oculta el marcador
vim.o.concealcursor = "" -- No oculta el marcador de la línea del cursor
vim.o.synmaxcol = 300 -- Límite de señalización de sintaxis

-- Configuraciones de comportamiento
vim.o.autowrite = false -- No escribe de forma automática
vim.o.autoread = true -- Carga automáticamente los archivos del editor
vim.o.swapfile = false
vim.o.errorbells = false -- Desactiva la campana de errores
vim.o.backspace = "indent,eol,start"
vim.o.mouse = "a" -- Activa el mouse

-- Configuración de folds
vim.o.foldlevelstart = 0 -- Todos los folds cerrados al abrir
vim.o.foldcolumn = "1" -- Muestra el nivel de doblado a la izquierda
vim.o.foldlevel = 0 -- Dobla el archivo a todos los niveles
vim.o.foldenable = true -- Permite mantener los folds de los bloques indentados

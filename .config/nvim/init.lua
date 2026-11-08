-- Punto de entrada de Neovim.
--
-- Estructura:
--   lua/config/   opciones, keymaps, autocmds, comandos, LSP y Java
--   lua/plugins/  configuración de cada plugin (incluido Tuxedo)
--   snippets/     snippets de LuaSnip (guía en snippets/README.md)
--
-- La configuración de Tuxedo vive en lua/plugins/tuxedo.lua: abre el TUI al
-- detectar todo.txt/done.txt, crea done.txt si falta y archiva las tareas
-- completadas sin borrar las entradas que ya existan en done.txt.

-- Debe ir antes de cualquier mapeo con <leader>
vim.g.mapleader = " "

-- Carga en caché los módulos Lua para acelerar el arranque
vim.loader.enable()

-- 1. Paquetes (gestor nativo de Neovim 0.12+)
require("config.pack")

-- 2. Opciones base (indentación, búsqueda, UI, folds, ...)
require("config.options")

-- 3. Autocmds y comandos propios
require("config.autocmds")
require("config.commands")

-- 4. Configuración de plugins
require("plugins.treesitter")
require("plugins.lualine")
require("plugins.todo-comments")
require("plugins.luasnip")
require("plugins.oil")
require("plugins.blink")
require("plugins.gitsigns")
require("plugins.which-key")
require("plugins.telescope")
require("plugins.conform")
require("config.snippets")
require("plugins.colorscheme")
require("plugins.tuxedo")

-- 5. LSP (Mason, servidores y diagnósticos)
require("config.lsp")
require("config.java")

-- 6. Keymaps generales al final: los plugins ya están configurados
require("config.keymaps")

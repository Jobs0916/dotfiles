-- To copy to system clipboard use "+y
-- To paste press p

vim.loader.enable()

-- Instalar las font

-- themes & transparency
-- Gestor de paquetes nvim 0.12+
vim.pack.add({
    -- Ejemplo de importacion de rutas bibliotecas completas vim pack
    -- { src = "https://github.com/folke/tokyonight.nvim" },
    --
    { src = "folke/tokyonight.nvim" },
    { src = "stevearc/oil.nvim" },
    { src = "nvim-tree/nvim-web-devicons" },
    { src = "echasnovski/mini.nvim" },
    { src = "echasnovski/mini.files" },
    { src = "echasnovski/mini.pick" },
    { src = "nvim-treesitter/nvim-treesitter" },
    { src = "neovim/nvim-lspconfig" },
    { src = "L3MON4D3/LuaSnip" },
    { src = "mason-org/mason.nvim" },
    { src = "mason-org/mason-lspconfig.nvim" },
    { src = "WhoIsSethDaniel/mason-tool-installer.nvim" },
    { src = "nvim-lualine/lualine.nvim" },
    { src = "chomosuke/typst-preview.nvim" },
    { src = "rafamadriz/friendly-snippets" },
    { src = "folke/which-key.nvim" },
    { src = "lewis6991/gitsigns.nvim" },
    { src = "folke/todo-comments.nvim" },
    { src = "stevearc/conform.nvim" },

    -- instalar todo
    { src = "saghen/blink.lib" },
    { src = "saghen/blink.cmp" },

    -- PARA INSTALAR gopls hay que usar vpn con mason
    { src = "ray-x/go.nvim" },
})

-- Bibliotecas de trabajo pendiente
-- require("mini.extra").setup({})
-- require("nvim-treesitter.configs").setup({ -- Para la version vieja de tree-setter
-- require("mini.files").setup({}) -- configurar

require("mini.pick").setup({})
require("lualine").setup({})
require("nvim-treesitter").setup({ -- Para la version nueva de tree-setter
    -- Autoinstall languages that are not installed
    auto_install = true,
    indent = { enable = true },
    highlight = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
    },
    build = ":TSUpdate",
    ensure_installed = {
        "python",
        "lua",
        "bash",
        "c",
        "cpp",
        "html",
        "asm",
        "scheme",
        "sql",
        "rust",
        "ada",
        -- Bibliotecas de go
        "go",
        "gomod",
        "gosum",
        "gowork",
        -- 'Scry',
        -- 'diff',
        -- 'luadoc',
    },
})

require("oil").setup({
    view_options = {
        show_hidden = true,
    },
})

require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = { "gopls" },
    automatic_installation = true,
})

require("mason-tool-installer").setup({
    ensure_installed = {
        "pyright",
        "lua_ls",
        "stylua",
        "tinymist",
        "rust-analyzer",
    },
})

require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
require("luasnip.loaders.from_vscode").lazy_load()

local cmp = require("blink.cmp")
cmp.build():pwait()
cmp.setup({
    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = { implementation = "rust" },
    completion = {
        documentation = { auto_show = true }, -- muestra documentación en ventana flotante
    },
    keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
        ["<C-space>"] = { "show", "hide" },
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
    },
})

require("go").setup({
    lsp_cfg = false,
    lsp_keymaps = false,
    diagnostic = { vim = true },
    go = { gofmt = "gofumpt", goimports = true },
    fillstruct = { mode = "sync" },
})

require("gitsigns").setup({
    signs = {
        add = { text = "+" }, ---@diagnostic disable-line: missing-fields
        change = { text = "~" }, ---@diagnostic disable-line: missing-fields
        delete = { text = "_" }, ---@diagnostic disable-line: missing-fields
        topdelete = { text = "‾" }, ---@diagnostic disable-line: missing-fields
        changedelete = { text = "~" }, ---@diagnostic disable-line: missing-fields
    },
})

require("which-key").setup({
    -- Delay between pressing a key and opening which-key (milliseconds)
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    -- Document existing key chains
    spec = {
        { "<leader>s", group = "[S]earch",    mode = { "n", "v" } },
        { "<leader>t", group = "[T]oggle" },
        { "<leader>h", group = "Git [H]unk",  mode = { "n", "v" } }, -- Enable gitsigns recommended keymaps first
        { "gr",        group = "LSP Actions", mode = { "n" } },
    },
})

require("todo-comments").setup({ signs = false })

-- Ruta de friendly snippets con pack
-- /home/dark/.local/share/nvim/site/pack/core/opt/friendly-snippets/snippets

vim.lsp.enable({ "lua_ls", "pyright", "tinymist", "rust-analyzer" }) -- Para activar el hover C-w C-d
vim.cmd.colorscheme("tokyonight-night")
vim.cmd("set clipboard=unnamedplus")

-- Diagnostico en pop-up
-- vim.api.nvim_create_autocmd("CursorHold", {})

-- Lsp on hover
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
    end,
})

vim.cmd("set completeopt+=noselect")

-- Lsp format on save
-- Version inicial
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp", { clear = true }),
    callback = function(args)
        -- 2
        vim.api.nvim_create_autocmd("BufWritePre", {
            -- 3
            buffer = args.buf,
            callback = function()
                -- 4 + 5
                vim.lsp.buf.format({ async = false, id = args.data.client_id })
            end,
        })
    end,
})

-- ============================================================
-- SECTION: FORMATTING
-- conform.nvim setup and keymap
-- ============================================================
do
    -- [[ Formatting ]]
    require("conform").setup({
        notify_on_error = false,
        format_on_save = function(bufnr)
            -- You can specify filetypes to autoformat on save here:
            local enabled_filetypes = {
                -- lua = true,
                -- python = true,
            }
            if enabled_filetypes[vim.bo[bufnr].filetype] then
                return { timeout_ms = 500 }
            else
                return nil
            end
        end,
        default_format_opts = {
            lsp_format = "fallback", -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
        },
        -- You can also specify external formatters in here.
        formatters_by_ft = {
            -- golang = { 'goformat' },
            -- Conform can also run multiple formatters sequentially
            -- python = { "isort", "black" },
            --
            -- You can use 'stop_after_first' to run the first available formatter from the list
            -- javascript = { "prettierd", "prettier", stop_after_first = true },
        },
    })

    vim.keymap.set({ "n", "v" }, "<C-s>", function()
        -- "<leader>f", function()
        require("conform").format({ async = true })
    end, { desc = "[F]ormat buffer" })
end

-- Descomentar para poner un background
-- vim.api.nvim_set_hl(0,"Normal",{ bg = "none" })
-- vim.api.nvim_set_hl(0,"NormalNC",{ bg = "none" })
-- vim.api.nvim_set_hl(0,"EndOfBuffer",{ bg = "none" })

-- Ajustes basicos
vim.o.number = true         -- Linea vertical numerica
vim.o.relativenumber = true -- Linea vertical numerica relativa
vim.o.cursorline = true     -- Marca la line donde esta el cursor
vim.o.scrolloff = 10        -- Muestra 10 lineas donde arriba y abajo del cursor
vim.o.sidescrolloff = 8     -- Muestra 8 lineas a la derecha e izquierda del cursor
vim.o.wrap = false          -- No dobla las lineas cuando se pasa del limite de la pantalla

-- Identacion
vim.o.tabstop = 4        -- Ancho de la tabulacion
vim.o.shiftwidth = 4     -- Ancho de la tabulacion
vim.o.softtabstop = 4    -- Ancho de la tabulacion suave
vim.o.expandtab = true   -- Usa espacios en vez de tabs
vim.o.smartindent = true -- Auto indentado inteligente
vim.o.autoindent = true  -- Copia el indentado desde la linea actual
vim.o.breakindent = true

-- Ajuste de busqueda
vim.o.ignorecase = true -- Busqueda insensitiva
vim.o.smartcase = true  -- Busqueda insensitiva si hayy mayuscula en la busqueda
vim.o.hlsearch = true   -- No mostrar los resultados senalizado
vim.o.incsearch = true  -- Muestra resultado mientras tecleas

-- Ajustes visuales
vim.o.syntax = "ON"                             -- Activa el visualizador sintactico
vim.o.winborder = "rounded"                     -- Activa bordes de las ventanas flotantes
vim.o.termguicolors = true                      -- Habilita los 24-bit de colores
vim.o.signcolumn = "yes"                        -- Muestra siempre la columna de simbolos
vim.o.showmatch = true                          -- Muestra las llaves, parentesis, y corchetes de cierre
vim.o.matchtime = 2                             -- (No funciona) Muestra por tiempo la pareja de cierre del caso anterior
vim.o.cmdheight = 1                             -- Altura de la linea de comandos
vim.o.completeopt = "menuone,noinsert,noselect" -- Opciones de completamiento
vim.o.colorcolumn = "100"                       -- Muestra una linea vertical cuando haya 100 carateres
vim.o.showmode = false                          -- No muestre los modos en la linea de comandos
vim.o.pumheight = 10                            -- ALtura de 10 la ventana pum de menu
vim.o.pumblend = 10                             -- Transparencia del pum en 10
vim.o.winblend = 0                              -- Pone flotante la ventana trasnparente
vim.o.conceallevel = 0                          -- No oculta el marcador
vim.o.concealcursor = ""                        -- No oculta el marcador de la linea del cursor
vim.o.lazyredraw = true                         -- No repintes durante macros
vim.o.synmaxcol = 300                           -- Limite de senalizacion de syntasis

-- Configuraciones de comportamiento
vim.o.autowrite = false              -- No escribe de forma automatica
vim.o.autoread = true                -- Carga automaticamente los archivos del editor
vim.o.swapfile = false
vim.o.hidden = true                  -- Permite los buffers ocultos
vim.o.errorbells = false             -- Desactivada la campana de errores
vim.o.backspace = "indent,eol,start" -- Desactivada la campana de errores
vim.o.mouse = "a"                    -- Activa el mouse

-- Configuraciones de comportamiento de fold
vim.o.foldlevelstart = 0 -- El nivel de fold es de 0 niveles de indentado, todos los fold cerrados
-- 99 son todos los niveles abiertos
vim.o.foldcolumn = "1"   -- Muestra el nivel de doblado a la izquierda de la columna
vim.o.foldlevel = 0      -- Dobla el archivo a todos los niveles
vim.o.foldenable = true  -- Permite que se  mantenga el (fold) todos los componentes indentados
-- vim.o.foldmethod = "indent" -- Dobla (fold) todos los componentes indentados
-- Sin el modo indent se dobla senalando todo y se presiona zf
-- Con el modo indent se abre un fold con zo y se cierra con zc,
-- se cierra todos los fold con zM y se abren todos con zR
-- Se ejecuta un toggle con el cursor sobre el fold con za

-- Tecla leader
vim.g.mapleader = " "

-- Atajos de teclados
-- vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Formatea el archivo actual", silent = true })
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { desc = "Elimina la senalizacion de busqueda", silent = true })
vim.keymap.set(
    "n",
    "<C-o>",
    ":update<CR> :source<CR>",
    { desc = "Actualiza y recarga el archivo de configuracion", silent = true }
)
vim.keymap.set("n", "<C-s>", ":write<CR>")
vim.keymap.set("n", "<C-q>", ":quit<CR>")

-- Limpia los elementos senalados con highlights search hlsearch
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Atajos de fold
vim.keymap.set("n", "-", "<cmd>foldclose<cr>", { desc = "Fold code area", silent = true })
vim.keymap.set("n", "+", "<cmd>foldopen<cr>", { desc = "Open code folded", silent = true })

-- Atajos de movimiento keymaps
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window", silent = true })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window", silent = true })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window", silent = true })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window", silent = true })

--  Y hasta EOL
vim.keymap.set("n", "Y", "y$", { desc = "Copia desde la poccion actual hasta el final de la linea", silent = true })

-- Navegacion adicionales
vim.keymap.set("n", "n", "nzzzv", { desc = "Muestra el proximo resultado de busqueda (centrado)", silent = true })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Muestra el resultado anterior de busqueda (centrado)", silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Navega hacia abajo y centra el contenido.", silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Navega hacia arriba y centra el contenido.", silent = true })

-- Mueve las lineas arriba y abajo
vim.keymap.set(
    "n",
    "<A-j>",
    ":m .+1<CR>==",
    { desc = "Mueve el contenido de la linea hacia abajo (modo normal)", silent = true }
)

vim.keymap.set(
    "n",
    "<A-k>",
    ":m .-2<CR>==",
    { desc = "Mueve el contenido de la linea hacia arriba (modo normal)", silent = true }
)

vim.keymap.set(
    "v",
    "<A-j>",
    ":m '>+1<CR>gv=gv",
    { desc = "Mueve el contenido de la linea hacia abajo (modo visual)", silent = true }
)

vim.keymap.set(
    "v",
    "<A-k>",
    ":m '<-2<CR>gv=gv",
    { desc = "Mueve el contenido de la linea hacia arriba (modo visual)", silent = true }
)

-- Identado a la derecha e izquierda
vim.keymap.set("v", "<", "<gv", { desc = "Mueve el contenido de la linea hacia arriba (modo normal)", silent = true })
vim.keymap.set("v", ">", ">gv", { desc = "Mueve el contenido de la linea hacia abajo (modo normal)", silent = true })

-- Navegacion de buffers
vim.keymap.set("n", "<Tab>", ":bnext <CR>", { desc = "Navega hacia el proximo buffer.", silent = true })
vim.keymap.set("n", "<S-Tab>", ":bprev<CR>", { desc = "Navega hacia el buffer anterior.", silent = true })
vim.keymap.set("n", "<leader>b", ":Pick buffers<CR>", { desc = "Muestra la lista de buffers.", silent = true })

-- Eliminacion de buffers excepto el actual
vim.keymap.set(
    { "n", "i", "v" },
    "<leader>wq",
    ":%bd|e# <CR>",
    { desc = "Cierra todos los buffers excepto el actual.", silent = true }
)

-- Reemplaza todas las coincidencias en el archivo actual
vim.keymap.set("v", "<leader>r", '"hy:%s/<C-r>h//g<left><left>')

-- Sale del modo insercion sin presionar escape
vim.keymap.set("i", "kj", "<Esc>")
vim.keymap.set("i", "jk", "<Esc>")

-- Cerrado automatico de pares, como llaves comillas, ect...
vim.keymap.set("i", '"', '""<left>')
vim.keymap.set("i", "'", "''<left>")
vim.keymap.set("i", "{", "{}<left>")
vim.keymap.set("i", "{;", "{};<left><left>")
vim.keymap.set("i", "(", "()<left>")
vim.keymap.set("i", "[", "[]<left>")
vim.keymap.set("i", "/*", "/**/<left><left>")

-- Atajos de teclados
vim.keymap.set("n", "-", ":Oil<CR>", { silent = true })
-- vim.keymap.set("n", "<leader>e", ":lua MiniFiles.open()<CR>", { silent = true })

-- Version de miniextra
-- vim.keymap.set('n','<leader>f',':lua MiniExtra.pickers.explorer()<CR>',{silent = true})
vim.keymap.set("n", "<leader>f", ":Pick files<CR>", { silent = true })
vim.keymap.set("n", "<Leader>h", ":Pick help<CR>", { silent = true })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- vim commands
-- vim.cmd(":hi statusline guibg=NONE")

-- Lua Snippets
-- Terminar despues

local ls = require("luasnip")
vim.keymap.set({ "i" }, "<Tab>", function()
    ls.expand()
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-L>", function()
    ls.jump(1)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function()
    ls.jump(-1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-E>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end, { silent = true })

vim.diagnostic.config({
    update_in_insert = false,
    severity_sort = true,
    float = { border = "rounded", source = "if_many" },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    -- Can switch between these as you prefer
    virtual_text = true, -- Text shows up at the end of the line
    virtual_lines = false, -- Text shows up underneath the line, with virtual lines

    -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
    jump = {
        on_jump = function(_, bufnr)
            vim.diagnostic.open_float({
                bufnr = bufnr,
                scope = "cursor",
                focus = false,
            })
        end,
    },
})

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

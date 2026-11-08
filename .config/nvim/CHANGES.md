# Cambios en `init.lua`

Resumen de las modificaciones realizadas en la sesión. Archivo: `.config/nvim/init.lua`.

## Tabla de cambios

| # | Área | Cambio | Antes | Después |
|---|------|--------|-------|---------|
| 1 | Keymaps | `<Esc>` duplicado | Dos mapeos a `nohlsearch` (línea 300 y 311; el 2º sin `desc`/`silent`) | Solo el de línea 265, con `desc` y `silent` |
| 2 | Keymaps | `<C-s>` en conflicto | Línea: `conform.format` + `:write` (el `:write` pisaba al formateo) | `<C-s>` formatea (síncrono, timeout 500ms, `lsp_format=fallback`) y luego guarda |
| 3 | Todo-comments | `]t` duplicado | Dos mapeos (`jump_next` general y filtrado por ERROR/WARNING) | Uno solo, versión completa (`jump_next` sin filtro) |
| 4 | Keymaps | `-` duplicado | `-` → `foldclose` (línea 310) y `-` → `:Oil` (línea 391) | Solo `-` → `:Oil` |
| 5 | Formateo | Guardado con conform | `format_on_save` con `enabled_filetypes` vacío (nunca formateaba) + autocmd `LspAttach` con `vim.lsp.buf.format` | Conform dueño del save: `format_on_save` para todos, skip si >100 000 líneas, `timeout_ms = 3000` |
| 6 | Formateo | Autocmd LSP eliminado | `LspAttach` creaba `BufWritePre` por cliente (formateo doble/leak) | Eliminado; conform es la única vía |
| 7 | Completado | Motor elegido | Mezcla `vim.lsp.completion` + blink | **blink.cmp** como único motor |
| 8 | Completado | `vim.lsp.completion` eliminado | Autocmd `LspAttach` con `vim.lsp.completion.enable` | Eliminado |
| 9 | Completado | keymap de blink | Sub-tablas `insert`/`auto`/`cmdline` (rompía el arranque: `keymap.cmdline` inválido) | Dict plano válido: `preset` + bindings (`<C-space>`, `<Tab>`, `<S-Tab>`, `<CR>`) |
| 10 | Paquetes | blink re-agregado | `blink.cmp` y `blink.lib` quitados de `vim.pack.add` | Re-agregados (líneas 30-31) |
| 11 | LuaSnip | mappings con `pumvisible` | `<Tab>`/`<S-Tab>` con `vim.fn.pumvisible()` para `vim.lsp.completion` | Eliminadas; la navegación del menú la gestiona blink |
| 12 | Limpieza | Código muerto eliminado (P5) | ~28 líneas: bloque `NOTE`, keymap `<leader>lf` comentado, bloque MiniFiles/Pick/MiniExtra/diagnóstico, `vim.cmd(":hi statusline")`, toggles de transparencia, docs de fold commentadas, "Terminar despues" | Eliminados; el init pasó de 431 a 403 líneas |
| 13 | LSP | Keymaps genéricos (P4) | No había `gd`, `K`, `gr`, `<leader>rn` | Autocmd `LspAttach` con keymaps buffer-locales: `gd` definición, `K` hover, `gr` referencias, `<leader>rn` renombrar |
| 14 | Orden | `mapleader` al inicio (P1) | Estaba en la línea 263, tras `vim.pack.add` y which-key | Movido a la línea 2, antes de todo mapeo/plugin |
| 15 | Opciones | Opciones muertas/conflictivas eliminadas (P2) | `vim.o.syntax="ON"` (chocaba con treesitter), `matchtime` (no funcionaba), `lazyredraw`, `hidden` (ya es default) | Eliminadas las 4; `hidden` sigue `true` por defecto |
| 16 | Mason | Lista alineada con `vim.lsp.enable` (P3) | `ensure_installed` tenía `tinymist`/`rust-analyzer` comentados pero `vim.lsp.enable` los habilitaba | Activados `tinymist` y `rust-analyzer` en `ensure_installed`; comentario `gopls` eliminado |
| 17 | Java | Sección completa (P6) | No había soporte Java | Añadido `nvim-jdtls` a `vim.pack.add`; ts_langs `"java"`; Mason: `jdtls`, `google-java-format`, `java-debug-adapter`, `java-test`; conform `java = { "google-java-format" }`; autocmd `FileType java` → `jdtls.start_or_attach` (root_dir, data por proyecto, bundles debug/test); keymaps `<leader>jo/jt/jr` |
| 18 | Tuxedo | `todo.txt`/`done.txt` abren `:Tuxedo` | Abrir esos ficheros mostraba solo texto plano; tuxedo.nvim solo se abría a mano con `:Tuxedo` | Nueva sección `SECTION: TUXEDO` (líneas 66-119): autocmd **`BufReadPost` + `BufNewFile`** con `pattern = { "todo.txt", "done.txt" }` → `vim.schedule` → `vim.cmd("Tuxedo")`. Guardas: existe el comando, el buffer actual sigue siendo el objetivo, no hay float de tuxedo abierto y sin UI (headless). `BufNewFile` es imprescindible porque `done.txt` puede no existir (abrir un fichero inexistente no dispara `BufReadPost`). Volver a un buffer ya cargado no reabre el TUI (sin anti-bucle). Probado: `nvim todo.txt`, `nvim done.txt` nuevo, `:e`, `:b` sin leer, no-reapertura al volver al buffer, cierre sin bucle y modo headless |

## Estado actual relevante

- **Completado**: blink.cmp + blink.lib (líneas 30-31, setup 106).
- **Formateo**: conform controla el formateo en guardado; `<C-s>` formatea y guarda; archivos >100k líneas se saltan.
- **blink en disco**: se eliminaron para prueba de reinstalación (`~/.local/share/nvim/site/pack/core/opt/blink.{cmp,lib}`). Se reinstalan automáticamente al abrir nvim.

## Pendiente (en curso)

- [ ] Probar reinstalación limpia de blink.cmp/blink.lib abriendo nvim.
  - `blink.cmp` y `blink.lib` se eliminaron de `~/.local/share/nvim/site/pack/core/opt/`.
  - Al arrancar, `vim.pack.add` los descarga de nuevo y regenera el lock.
  - Verificar que no haya error `keymap.cmdline` y que el menú de completado aparezca.

## Propuestos (no aplicados aún)

> Los propuestos P1–P6 ya fueron ejecutados. Se mantienen como referencias históricas.

| # | Área | Cambio propuesto | Detalle |
|---|------|------------------|---------|
| P1 | Orden | Mover `vim.g.mapleader` al inicio | ✅ Aplicado: línea 2. |
| P2 | Opciones | Eliminar opciones muertas/conflictivas | ✅ Aplicado. |
| P3 | Mason | Una sola fuente de verdad | ✅ Aplicado. |
| P4 | LSP | Keymaps genéricos faltantes | ✅ Aplicado. |
| P5 | Limpieza | Quitar código muerto | ✅ Aplicado. |
| P6 | Java | Sección completa para Java | ✅ Aplicado. |

### Configuración propuesta para Java

| Componente | Acción |
|------------|--------|
| Plugin | `mfussenegger/nvim-jdtls` añadido (descargado al arrancar) |
| Treesitter | `"java"` añadido a `ts_langs` |
| Mason (`ensure_installed`) | `jdtls`, `google-java-format`, `java-debug-adapter`, `java-test` |
| Conform | `formatters_by_ft.java = { "google-java-format" }` |
| Arranque LSP | Autocmd `FileType java` → `require("jdtls").start_or_attach({ cmd, root_dir, data, bundles })` |
| Keymaps Java | `<leader>jo` organizar imports, `<leader>jt` test clase, `<leader>jr` restart frame |
| Sistema | JDK 21+, Maven/Gradle, opcional Lombok (`-javaagent`) |
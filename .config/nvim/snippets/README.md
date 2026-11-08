# Snippets personales (LuaSnip)

Esta configuración usa **LuaSnip** para los snippets y **blink.cmp** para el menú de
completado. La carpeta raíz de tus snippets vive **dentro de la configuración de
Neovim**:

```text
~/.config/nvim/snippets/
```

La ruta se calcula con `vim.fn.stdpath("config")`, así que también funciona si
mueves la configuración o usas otro `NVIM_APPNAME`. Puedes comprobarla con:

```vim
:lua print(vim.g.snippets_dir)
```

El único sitio donde viven tus snippets es esta carpeta. Puedes añadirlos
editando archivos `.lua` o, sin escribir Lua, con el asistente integrado
(`:SnippetNew`). En ambos casos no hace falta modificar `init.lua`.

## Cómo se cargan

La carga está repartida entre `lua/plugins/luasnip.lua` y `lua/config/snippets.lua`:

- `from_lua.load({ paths = vim.g.snippets_dir })` carga todos los `.lua` de la
  carpeta al arrancar y recarga los archivos al guardarlos desde Neovim.
  Para cambios hechos fuera de Neovim, usa `:SnippetsReload`.
- `lua/config/snippets.lua` carga `snippets/custom.json`, donde el asistente
  guarda los snippets creados con `:SnippetNew`, y los registra en LuaSnip.
- `enable_autosnippets = true` activa los autosnippets.
- `from_vscode.lazy_load()` carga `friendly-snippets`, que ya viene instalado.
- `:SnippetsReload` vuelve a cargar todo (Lua, friendly-snippets y
  `custom.json`) sin reiniciar Neovim.
- `:Snippets` abre la carpeta con Oil.

## Asistente para crear snippets (sin escribir Lua)

Si no quieres editar los archivos `.lua` a mano, usa el asistente:

| Comando | Acción |
| --- | --- |
| `:SnippetNew` | Crea un snippet paso a paso. |
| `:SnippetList` | Lista, edita o elimina los snippets del asistente. |
| `:SnippetReload` | Recarga `snippets/custom.json` sin reiniciar Neovim. |

El asistente pregunta por el filetype (varios separados por coma, o `all` para
todos), el trigger, la descripción, el cuerpo y el tipo (normal o autosnippet).
El cuerpo se escribe en una ventana flotante: `<C-s>` (o `:w`) guarda y `q`
cancela.

El cuerpo usa la sintaxis de snippets LSP/VSCode:

- `$1`, `$2`, … campos editables en orden.
- `${1:valor}` campo con valor inicial.
- `$0` posición final del cursor.
- `${1|uno,dos|}` elección entre opciones.

Ejemplo de cuerpo para un `for` en C:

```text
for (int ${1:i} = 0; $1 < ${2:n}; $1++) {
	$0
}
```

Los snippets del asistente se guardan en `snippets/custom.json`. Los archivos
`.lua` de esta carpeta siguen funcionando igual y no se modifican. Al cargar el
JSON se valida; si está roto, se avisa y el asistente no lo sobrescribe.

## El nombre del archivo es el filetype

LuaSnip deduce el filetype del nombre del archivo:

| Archivo | Se aplica a |
| --- | --- |
| `snippets/all.lua` | Todos los filetypes |
| `snippets/lua.lua` | `filetype=lua` |
| `snippets/python.lua` | `filetype=python` |
| `snippets/c.lua` | `filetype=c` |
| `snippets/markdown.lua` | `filetype=markdown` |
| `snippets/java/spring.lua` | `filetype=java` (subcarpeta) |

Para saber el filetype del buffer actual:

```vim
:set filetype?
" o
:lua print(vim.bo.filetype)
```

`README.md` y cualquier archivo que no termine en `.lua` se ignoran.

`custom.json` es la excepción: no representa un filetype, lo gestiona el
asistente (`:SnippetNew` / `:SnippetList`).

## Estructura de un archivo

Un archivo de snippets puede devolver una lista:

```lua
return {
  s({ trig = "req", dscr = "require local" }, {
    t("local "), i(1, "mod"), t(' = require("'), rep(1), t('")'),
  }),
}
```

O dos listas: primero snippets normales y después autosnippets:

```lua
return {
  -- snippets normales
  s(...),
}, {
  -- autosnippets
  s({ trig = "vint", snippetType = "autosnippet" }, { ... }),
}
```

Dentro de estos archivos tienes disponibles los constructores de LuaSnip sin
hacer `require`: `s`, `t`, `i`, `c`, `f`, `rep`, `sn`, `fmt`, `parse`, etc.

## Anatomía de un snippet

```lua
s(
  {
    trig = "req",              -- texto que se escribe para expandirlo
    dscr = "require local",    -- descripción en el menú de completado
    snippetType = "snippet",   -- "snippet" (manual) o "autosnippet"
    priority = 1000,           -- mayor gana si hay triggers repetidos
  },
  {
    t("local "),               -- texto literal
    i(1, "mod"),               -- campo editable (orden 1, valor inicial "mod")
    t(' = require("'),
    rep(1),                    -- repite el contenido del campo 1
    t('")'),
    i(0),                      -- posición final del cursor (opcional)
  }
)
```

### Nodos más usados

| Nodo | Para qué sirve |
| --- | --- |
| `t("texto")` | Texto fijo. También acepta una lista de líneas: `t({ "", "\t" })`. |
| `i(n, "inicial")` | Campo editable. `i(0)` es la posición final del cursor. |
| `c(n, { ... })` | Elección entre varias opciones. |
| `f(function(_, parent) ... end)` | Texto calculado con una función Lua. |
| `rep(n)` | Repite el contenido de otro campo. |
| `sn(n, { ... })` | Snippet anidado dentro de otro. |
| `fmt("texto {} y {}", { i(1), i(2) })` | Plantilla con placeholders; útil para textos largos. |

## Ejemplo: `snippets/lua.lua`

Este archivo ya está creado con dos ejemplos:

```lua
---@diagnostic disable: undefined-global

return {
  -- req -> local mod = require("mod")
  s({ trig = "req", dscr = "require local" }, {
    t("local "),
    i(1, "mod"),
    t(' = require("'),
    rep(1),
    t('")'),
  }),

  -- fn -> local function nombre(args)
  --           <cursor>
  --       end
  s({ trig = "fn", dscr = "Función local" }, {
    t("local function "),
    i(1, "nombre"),
    t("("),
    i(2, "args"),
    t(")"),
    t({ "", "\t" }),
    i(0),
    t({ "", "end" }),
  }),
}
```

## Cómo expandir y navegar

1. **Menú de completado (recomendado):** escribe `req`, abre el menú con
   `<C-space>` y elige el snippet con `<Tab>` o `<CR>`. blink.cmp inserta el
   snippet y LuaSnip toma el control de los campos.
2. **Expansión manual:** escribe el trigger y pulsa `<C-k>`.
   (`<C-k>` sustituye al atajo de digraph de Vim; si lo usas, cambia el mapeo en
   `lua/plugins/luasnip.lua`.)
3. **Saltar campos:** `<C-L>` avanza, `<C-J>` retrocede.
4. **Elegir en un `c(...)`:** `<C-E>` cambia la opción.
5. **Autosnippets:** se expanden solos al escribir el trigger, sin `<C-k>`.

## Autosnippets

Se declaran con `snippetType = "autosnippet"` y ya están activados en la
configuración (`enable_autosnippets = true`). Ejemplo de `snippets/c.lua`:

```lua
return {
  s({ trig = "vint", snippetType = "autosnippet", dscr = "Declaración int" }, {
    t("int "),
    i(1, "var"),
    t(" = 0;"),
  }),
}
```

Al escribir `vint` se expande automáticamente. Usa triggers distintivos: un
autosnippet con un trigger demasiado corto puede dispararse sin querer.

## Snippets globales

`snippets/all.lua` se aplica a todos los filetypes. Ejemplo con texto calculado:

```lua
---@diagnostic disable: undefined-global

return {
  s({ trig = "hoy", dscr = "Fecha actual" }, {
    f(function()
      return os.date("%Y-%m-%d")
    end),
  }),
}
```

## Snippet para otro lenguaje

1. Abre un archivo de ese lenguaje y comprueba el filetype con `:set filetype?`.
2. Crea `~/.config/nvim/snippets/<filetype>.lua`.
3. Añade tus `s(...)` y guarda.
4. Ejecuta `:SnippetsReload`.
5. Prueba el trigger con `<C-k>` o desde el menú de completado.

Ejemplo para Python (`snippets/python.lua`):

```lua
---@diagnostic disable: undefined-global

return {
  s({ trig = "def", dscr = "Definir función" }, {
    t("def "),
    i(1, "nombre"),
    t("("),
    i(2, "args"),
    t("):"),
    t({ "", "\t" }),
    i(0),
  }),
}
```

## Editar, recargar y depurar

| Acción | Comando |
| --- | --- |
| Crear un snippet con el asistente | `:SnippetNew` |
| Listar, editar o eliminar | `:SnippetList` |
| Recargar solo `custom.json` | `:SnippetReload` |
| Abrir la carpeta de snippets | `:Snippets` |
| Recargar todo sin reiniciar | `:SnippetsReload` |
| Ver errores de carga | `:messages` |
| Abrir el log de LuaSnip | `:lua require("luasnip").log.open()` |
| Ver los filetypes activos | `:lua print(vim.inspect(require("luasnip").get_snippet_filetypes()))` |
| Ver triggers de un filetype | `:lua for _, sn in ipairs(require("luasnip").get_snippets("lua")) do print(sn.trigger) end` |
| Ver autosnippets | `:lua for _, sn in ipairs(require("luasnip").get_snippets("lua", { type = "autosnippets" })) do print(sn.trigger) end` |

Si un snippet no aparece:

1. Comprueba que el archivo se llama igual que el filetype (`lua.lua` para Lua,
   `python.lua` para Python...).
2. Ejecuta `:SnippetsReload`.
3. Revisa `:messages` por si el archivo tiene un error de sintaxis Lua.
4. Recuerda que `wordTrig` está activo por defecto: el trigger debe empezar en
   un límite de palabra, no pegado a otra palabra.
5. Si borraste un archivo y el snippet sigue apareciendo, `:SnippetsReload`
   limpia y vuelve a cargar; si persiste, reinicia Neovim.

## Notas

- `friendly-snippets` sigue disponible; tus snippets conviven con él.
- Si dos snippets comparten trigger, gana el de mayor `priority`; si empatan,
  el que se haya cargado antes.
- `---@diagnostic disable: undefined-global` al inicio del archivo evita que
  `lua_ls` marque `s`, `t`, `i`, etc. como variables no definidas. No afecta al
  funcionamiento del snippet.
- Los snippets se guardan como archivos Lua dentro de la configuración, así que
  entran en el repositorio de dotfiles junto con el resto de la configuración.

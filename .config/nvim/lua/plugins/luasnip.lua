-- LuaSnip: snippets personalizados.
--
-- Carpeta raíz (dentro de la configuración de Neovim):
--   ~/.config/nvim/snippets/
--
-- Un fichero por filetype: lua.lua, python.lua, c.lua, javascript.lua, etc.
-- all.lua se aplica a todos los filetypes. La guía completa está en
-- snippets/README.md.
--
-- Además, :SnippetNew crea snippets sin escribir Lua; se guardan en
-- snippets/custom.json (ver lua/config/snippets.lua).

local ls = require("luasnip")
local snippets_dir = vim.fs.joinpath(vim.fn.stdpath("config"), "snippets")

-- Se crea al arrancar para que siempre exista la carpeta raíz.
vim.fn.mkdir(snippets_dir, "p")
vim.g.snippets_dir = snippets_dir

ls.setup({
	enable_autosnippets = true,
})

local lua_loader = require("luasnip.loaders.from_lua")
local vscode_loader = require("luasnip.loaders.from_vscode")

-- Carga todos los .lua de la carpeta personalizada (no perezoso: están
-- disponibles desde el primer momento y se recargan al guardarlos desde Neovim).
lua_loader.load({ paths = snippets_dir })

-- friendly-snippets (paquete ya instalado) y cualquier colección VSCode del
-- runtimepath.
vscode_loader.lazy_load()

-- Vuelve a cargar todo sin reiniciar Neovim. Útil después de crear o editar
-- un fichero de snippets.
vim.api.nvim_create_user_command("SnippetsReload", function()
	ls.cleanup()
	lua_loader.load({ paths = snippets_dir })
	vscode_loader.lazy_load()
	local custom_ok = require("config.snippets").reload()
	vim.notify(
		custom_ok and ("Snippets recargados: " .. snippets_dir)
			or "Snippets Lua recargados; revisa snippets/custom.json.",
		custom_ok and vim.log.levels.INFO or vim.log.levels.WARN
	)
end, { desc = "Recarga los snippets de la carpeta personalizada" })

-- Abre la carpeta de snippets con Oil.
vim.api.nvim_create_user_command("Snippets", function()
	vim.cmd("Oil " .. vim.fn.fnameescape(snippets_dir))
end, { desc = "Abre la carpeta de snippets personalizados" })

-- Expansión manual: escribe el trigger y pulsa <C-k>.
-- (Con blink.cmp también puedes elegir el snippet desde el menú de completado.)
vim.keymap.set({ "i", "s" }, "<C-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true, desc = "LuaSnip: expandir snippet o saltar" })

-- Navegación por los campos del snippet.
-- La navegación del menú de completado la gestiona blink.cmp (Tab/S-Tab).
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

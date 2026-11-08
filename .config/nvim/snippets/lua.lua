---@diagnostic disable: undefined-global
-- Snippets para Lua (incluida esta configuración de Neovim).
--
-- Expansión:
--   * escribe el trigger y pulsa <C-k>, o
--   * escribe el trigger, abre el menú con <C-space> y elige con <Tab>/<CR>.
-- Navegación: <C-L> avanza, <C-J> retrocede, <C-E> cambia una elección.
-- Guía completa: README.md.

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

---@diagnostic disable: undefined-global
-- Snippets para C.
--
-- s = snippet, t = texto, i = campo editable, rep = repetir un campo.
-- La guía completa está en README.md.

return {
	-- Escribe vint y se expande solo (snippetType = "autosnippet").
	s({ trig = "vint", snippetType = "autosnippet", dscr = "Declaración int" }, {
		t("int "),
		i(1, "var"),
		t(" = 0;"),
	}),

	-- Escribe forr y pulsa <C-k> (o elige el snippet en el menú de completado).
	s({ trig = "forr", dscr = "Bucle for con índice" }, {
		t("for (int "),
		i(1, "i"),
		t(" = 0; "),
		rep(1),
		t(" < "),
		i(2, "n"),
		t("; "),
		rep(1),
		t("++) {"),
		t({ "", "\t" }),
		i(0),
		t({ "", "}" }),
	}),
}

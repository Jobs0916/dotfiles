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
		["<C-space>"] = { "show", "hide" },
		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" },
		["<CR>"] = { "accept", "fallback" },
	},
})

require("oil").setup({
	view_options = {
		show_hidden = true,
	},
})

-- Abre el explorador de archivos
vim.keymap.set("n", "-", ":Oil<CR>", { silent = true })

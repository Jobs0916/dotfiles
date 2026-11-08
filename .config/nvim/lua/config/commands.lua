-- Comandos de usuario propios.

vim.api.nvim_create_user_command("BorrarLineasVacias", function()
	vim.cmd([[%g/^\s*$/d]])
end, { desc = "Elimina líneas en blanco en todo el documento" })

-- Keymaps generales.
-- Los keymaps propios de cada plugin viven en lua/plugins/<plugin>.lua.

-- Atajos de teclado
vim.keymap.set("n", "<leader>sc", ":BorrarLineasVacias<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { desc = "Elimina la señalización de búsqueda", silent = true })
vim.keymap.set(
	"n",
	"<C-o>",
	":update<CR> :source<CR>",
	{ desc = "Actualiza y recarga el archivo de configuración", silent = true }
)
vim.keymap.set("n", "<C-q>", ":quit<CR>")

-- Atajos de fold
vim.keymap.set("n", "+", "<cmd>foldopen<cr>", { desc = "Open code folded", silent = true })

-- Movimiento entre ventanas
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window", silent = true })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window", silent = true })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window", silent = true })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window", silent = true })

-- Y hasta EOL
vim.keymap.set("n", "Y", "y$", { desc = "Copia desde la posición actual hasta el final de la línea", silent = true })

-- Navegación adicional
vim.keymap.set("n", "n", "nzzzv", { desc = "Muestra el próximo resultado de búsqueda (centrado)", silent = true })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Muestra el resultado anterior de búsqueda (centrado)", silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Navega hacia abajo y centra el contenido", silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Navega hacia arriba y centra el contenido", silent = true })

-- Mueve las líneas arriba y abajo
vim.keymap.set(
	"n",
	"<A-j>",
	":m .+1<CR>==",
	{ desc = "Mueve el contenido de la línea hacia abajo (modo normal)", silent = true }
)
vim.keymap.set(
	"n",
	"<A-k>",
	":m .-2<CR>==",
	{ desc = "Mueve el contenido de la línea hacia arriba (modo normal)", silent = true }
)
vim.keymap.set(
	"v",
	"<A-j>",
	":m '>+1<CR>gv=gv",
	{ desc = "Mueve el contenido de la línea hacia abajo (modo visual)", silent = true }
)
vim.keymap.set(
	"v",
	"<A-k>",
	":m '<-2<CR>gv=gv",
	{ desc = "Mueve el contenido de la línea hacia arriba (modo visual)", silent = true }
)

-- Indentado a la derecha e izquierda
vim.keymap.set("v", "<", "<gv", { desc = "Indenta a la izquierda y mantiene la selección", silent = true })
vim.keymap.set("v", ">", ">gv", { desc = "Indenta a la derecha y mantiene la selección", silent = true })

-- Navegación de buffers
vim.keymap.set("n", "<Tab>", ":bnext <CR>", { desc = "Navega hacia el próximo buffer", silent = true })
vim.keymap.set("n", "<S-Tab>", ":bprev<CR>", { desc = "Navega hacia el buffer anterior", silent = true })
vim.keymap.set("n", "<leader>b", ":Pick buffers<CR>", { desc = "Muestra la lista de buffers", silent = true })

-- Eliminación de buffers excepto el actual
vim.keymap.set(
	{ "n", "i", "v" },
	"<leader>wq",
	":%bd|e# <CR>",
	{ desc = "Cierra todos los buffers excepto el actual", silent = true }
)

-- Reemplaza todas las coincidencias en el archivo actual
vim.keymap.set("v", "<leader>r", '"hy:%s/<C-r>h//g<left><left>')

-- Sale del modo inserción sin presionar escape
vim.keymap.set("i", "kj", "<Esc>")
vim.keymap.set("i", "jk", "<Esc>")

-- Cierre automático de pares
vim.keymap.set("i", '"', '""<left>')
vim.keymap.set("i", "'", "''<left>")
vim.keymap.set("i", "{", "{}<left>")
vim.keymap.set("i", "{;", "{};<left><left>")
vim.keymap.set("i", "(", "()<left>")
vim.keymap.set("i", "[", "[]<left>")
vim.keymap.set("i", "/*", "/**/<left><left>")

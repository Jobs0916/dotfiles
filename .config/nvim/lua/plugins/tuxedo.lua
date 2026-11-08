-- Integración de Tuxedo (TUI de todo.txt) con Neovim.
--
--   * Abre el TUI automáticamente al abrir todo.txt o done.txt.
--   * Crea done.txt junto a todo.txt si todavía no existe.
--   * Fija TODO_FILE y DONE_FILE para que Tuxedo use exactamente esos ficheros.
--   * Al cerrar el TUI ejecuta `tuxedo archive`: todas las tareas completadas
--     se añaden al final de done.txt y se conservan las líneas que ya existían.

local M = {}

local tuxedo = require("tuxedo")
local group = vim.api.nvim_create_augroup("tuxedo-auto-open", { clear = true })

-- Contexto por buffer de terminal: [termbuf] = { todo = ..., done = ... }
local pendientes = {}

-- Evita que `checktime` (que dispara BufReadPost) vuelva a abrir el TUI justo
-- después de cerrarlo.
local recargando = false

local function absoluto(path)
	return vim.fn.fnamemodify(path, ":p")
end

local function crear_si_falta(path)
	if vim.fn.filereadable(path) == 0 then
		vim.fn.mkdir(vim.fs.dirname(path), "p")
		vim.fn.writefile({}, path)
	end
end

-- Devuelve todo.txt y done.txt para el buffer indicado.
-- Si el buffer es todo.txt/done.txt usa su carpeta; en otro caso, el root del
-- proyecto (o el cwd), igual que hace tuxedo.nvim.
local function rutas(buf)
	local name = vim.api.nvim_buf_get_name(buf)
	local base = vim.fs.basename(name)

	if base == "todo.txt" or base == "done.txt" then
		local dir = vim.fs.dirname(absoluto(name))
		return vim.fs.joinpath(dir, "todo.txt"), vim.fs.joinpath(dir, "done.txt")
	end

	local root = vim.fs.root(buf, { ".git" }) or vim.fn.getcwd()
	return vim.fs.joinpath(root, "todo.txt"), vim.fs.joinpath(root, "done.txt")
end

local function es_terminal_tuxedo(buf)
	if not vim.api.nvim_buf_is_loaded(buf) then
		return false
	end
	local bo = vim.bo[buf]
	return bo.buftype == "terminal" and bo.filetype == "todo"
end

local function terminal_tuxedo()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if es_terminal_tuxedo(buf) then
			return buf
		end
	end
end

local function tuxedo_abierto()
	return terminal_tuxedo() ~= nil
end

-- Ejecuta `tuxedo archive` con las rutas detectadas. Tuxedo lee done.txt,
-- añade las tareas completadas al final y deja intactas las líneas previas;
-- después elimina esas tareas de todo.txt (archivado estándar de todo.txt).
local function archivar_completadas(todo, done)
	if vim.fn.executable("tuxedo") ~= 1 then
		return
	end
	crear_si_falta(done)
	if vim.fn.filereadable(todo) == 0 then
		return
	end

	local ok, job = pcall(function()
		return vim.system(
			{ "tuxedo", "archive" },
			{ env = { TODO_FILE = todo, DONE_FILE = done }, text = true }
		):wait(5000)
	end)

	if not ok then
		vim.notify("Tuxedo: no se pudo archivar en done.txt", vim.log.levels.WARN)
		return
	end
	if job.code ~= 0 then
		local detalle = job.stderr and job.stderr ~= "" and job.stderr or "error desconocido"
		vim.notify("Tuxedo: archive falló: " .. detalle, vim.log.levels.WARN)
	end
end

local function recargar_buffers()
	recargando = true
	vim.cmd("silent! checktime")
	vim.schedule(function()
		recargando = false
	end)
end

-- Abre el TUI. `buf` es el buffer que disparó la apertura automática.
function M.abrir(buf)
	local todo, done = rutas(buf)

	-- Garantiza que done.txt exista desde la primera apertura.
	crear_si_falta(done)

	-- Tuxedo resuelve primero TODO_FILE y calcula done.txt desde DONE_FILE.
	vim.env.TODO_FILE = todo
	vim.env.DONE_FILE = done

	-- Recuerda qué buffers de terminal ya existían para no reetiquetar uno
	-- abierto con otra ruta (por ejemplo, al invocar :Tuxedo dos veces).
	local existentes = {}
	for _, term in ipairs(vim.api.nvim_list_bufs()) do
		if es_terminal_tuxedo(term) then
			existentes[term] = true
		end
	end

	tuxedo.tuxedo()

	for _, term in ipairs(vim.api.nvim_list_bufs()) do
		if es_terminal_tuxedo(term) and not existentes[term] then
			pendientes[term] = { todo = todo, done = done }
			break
		end
	end
end

tuxedo.setup({
	create_todo_file = true,
	width_ratio = 0.95,
	height_ratio = 0.80,
})

-- Sustituye :Tuxedo por una variante que prepara done.txt y las variables de
-- entorno. Así el comportamiento también aplica al abrir el comando a mano.
-- El plugin registra su propio :Tuxedo en plugin/tuxedo.lua (se carga después
-- de init.lua), por eso se vuelve a definir en VimEnter.
local function definir_comando_tuxedo()
	vim.api.nvim_create_user_command("Tuxedo", function()
		M.abrir(vim.api.nvim_get_current_buf())
	end, { force = true, desc = "Abrir Tuxedo con todo.txt/done.txt del proyecto" })
end

definir_comando_tuxedo()
vim.api.nvim_create_autocmd("VimEnter", {
	group = group,
	once = true,
	callback = definir_comando_tuxedo,
})

-- Al salir del TUI archiva las tareas completadas. `TermClose` se dispara
-- cuando termina el proceso `tuxedo`; se programa para que el fichero ya esté
-- cerrado y `checktime` recargue los buffers afectados.
vim.api.nvim_create_autocmd("TermClose", {
	group = group,
	callback = function(ev)
		local ctx = pendientes[ev.buf]
		if not ctx then
			return
		end
		pendientes[ev.buf] = nil
		vim.schedule(function()
			archivar_completadas(ctx.todo, ctx.done)
			recargar_buffers()
		end)
	end,
})

-- Abre el TUI al leer/crear todo.txt o done.txt. Se ejecuta fuera del autocmd
-- para que la UI ya esté lista; volver a un buffer ya cargado no lo reabre.
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	group = group,
	pattern = { "todo.txt", "done.txt" },
	callback = function(ev)
		local base = vim.fs.basename(vim.api.nvim_buf_get_name(ev.buf))
		if base ~= "todo.txt" and base ~= "done.txt" then
			return
		end
		vim.schedule(function()
			if recargando then
				return -- recarga provocada por el archivado: no reabrir el TUI
			end
			if vim.api.nvim_get_current_buf() ~= ev.buf then
				return -- el foco ya cambió: no robar la ventana
			end
			if tuxedo_abierto() then
				return -- ya hay un Tuxedo abierto
			end
			if #vim.api.nvim_list_uis() == 0 then
				return -- headless: sin UI no hay terminal que abrir
			end
			M.abrir(ev.buf)
		end)
	end,
})

return M

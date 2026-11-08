-- Snippets personalizados gestionados con un asistente.
--
-- Los ficheros .lua de snippets/ siguen funcionando igual. Los snippets
-- creados con el asistente se guardan en snippets/custom.json y se registran
-- en LuaSnip al arrancar.
--
-- Comandos:
--   :SnippetNew     Crea un snippet paso a paso.
--   :SnippetList    Lista, edita o elimina snippets personalizados.
--   :SnippetReload  Recarga custom.json sin reiniciar Neovim.
--
-- El cuerpo usa la sintaxis de snippets LSP/VSCode: $1, ${1:valor}, $0, etc.

local ls = require("luasnip")

local M = {}

local levels = vim.log.levels
local snippets_dir = vim.g.snippets_dir or vim.fs.joinpath(vim.fn.stdpath("config"), "snippets")
local data_path = vim.fs.joinpath(snippets_dir, "custom.json")
local add_key = "nvim-config/custom-snippets"
local default_priority = 2000

M.specs = {}
M.broken = nil

local function notify(msg, level)
	vim.notify("[snippets] " .. msg, level or levels.INFO)
end

---Compara dos rutas resolviendo enlaces simbólicos (p. ej. stow).
---@param a string
---@param b string
---@return boolean
local function same_path(a, b)
	local resolved_a = vim.uv.fs_realpath(a) or vim.fs.normalize(a)
	local resolved_b = vim.uv.fs_realpath(b) or vim.fs.normalize(b)
	return resolved_a == resolved_b
end

---@param value any
---@param index integer
---@return string[]|nil, string|nil
local function normalize_filetypes(value, index)
	if type(value) == "string" then
		value = vim.split(value, ",", { plain = true })
	end
	if type(value) ~= "table" then
		return nil, ("entrada %d: 'filetypes' debe ser una lista"):format(index)
	end

	local result = {}
	local seen = {}
	for _, item in ipairs(value) do
		if type(item) ~= "string" then
			return nil, ("entrada %d: cada filetype debe ser texto"):format(index)
		end
		local ft = vim.trim(item):lower()
		if ft ~= "" and not seen[ft] then
			seen[ft] = true
			result[#result + 1] = ft
		end
	end

	if #result == 0 then
		return nil, ("entrada %d: falta 'filetypes'"):format(index)
	end
	if seen.all then
		return { "all" }
	end
	return result
end

---@param raw any
---@param index integer
---@return table|nil, string|nil
local function normalize_spec(raw, index)
	if type(raw) ~= "table" then
		return nil, ("entrada %d: se esperaba un objeto"):format(index)
	end

	local trigger = type(raw.trigger) == "string" and vim.trim(raw.trigger) or ""
	if trigger == "" then
		return nil, ("entrada %d: falta 'trigger'"):format(index)
	end
	if trigger:find("%s") then
		return nil, ("entrada %d: el trigger no puede contener espacios"):format(index)
	end

	if type(raw.body) ~= "string" or raw.body == "" then
		return nil, ("entrada %d: falta 'body'"):format(index)
	end

	local description = raw.description
	if description == nil then
		description = trigger
	elseif type(description) ~= "string" then
		return nil, ("entrada %d: 'description' debe ser texto"):format(index)
	end
	description = vim.trim(description)
	if description == "" then
		description = trigger
	end

	local filetypes, ft_err = normalize_filetypes(raw.filetypes or raw.filetype, index)
	if not filetypes then
		return nil, ft_err
	end

	local kind = raw.type or "snippet"
	if kind ~= "snippet" and kind ~= "autosnippet" then
		return nil, ("entrada %d: 'type' debe ser 'snippet' o 'autosnippet'"):format(index)
	end

	local priority = raw.priority
	if priority == nil then
		priority = default_priority
	elseif type(priority) ~= "number" then
		return nil, ("entrada %d: 'priority' debe ser un número"):format(index)
	end

	return {
		filetypes = filetypes,
		trigger = trigger,
		description = description,
		body = raw.body,
		type = kind,
		priority = math.floor(priority),
	}
end

---@param spec table
---@return table
local function build_snippet(spec)
	return ls.parser.parse_snippet({
		trig = spec.trigger,
		dscr = spec.description,
		snippetType = spec.type,
		priority = spec.priority,
	}, spec.body)
end

---@return table[]|nil, string|nil
local function read_specs()
	local fd, open_err = io.open(data_path, "r")
	if not fd then
		if vim.uv.fs_stat(data_path) == nil then
			return {}
		end
		return nil, "no se pudo abrir " .. data_path .. ": " .. tostring(open_err)
	end

	local content = fd:read("*a")
	fd:close()
	if content == nil then
		return nil, "no se pudo leer " .. data_path
	end
	if vim.trim(content) == "" then
		return {}
	end

	local ok, decoded = pcall(vim.json.decode, content)
	if not ok then
		return nil, "JSON inválido en " .. data_path .. ": " .. tostring(decoded)
	end
	if type(decoded) ~= "table" or not vim.islist(decoded) then
		return nil, "se esperaba una lista JSON en " .. data_path
	end

	local specs = {}
	for index, raw in ipairs(decoded) do
		local spec, err = normalize_spec(raw, index)
		if not spec then
			return nil, err
		end

		local parsed, parse_err = pcall(build_snippet, spec)
		if not parsed then
			return nil, ("entrada %d (%s): cuerpo inválido: %s"):format(index, spec.trigger, tostring(parse_err))
		end
		specs[#specs + 1] = spec
	end
	return specs
end

---@param specs table[]
---@return string
local function serialize(specs)
	if #specs == 0 then
		return "[]\n"
	end

	local lines = { "[" }
	for index, spec in ipairs(specs) do
		local filetypes = {}
		for _, ft in ipairs(spec.filetypes) do
			filetypes[#filetypes + 1] = vim.json.encode(ft)
		end

		lines[#lines + 1] = "  {"
		lines[#lines + 1] = '    "filetypes": [' .. table.concat(filetypes, ", ") .. "],"
		lines[#lines + 1] = '    "trigger": ' .. vim.json.encode(spec.trigger) .. ","
		lines[#lines + 1] = '    "description": ' .. vim.json.encode(spec.description) .. ","
		lines[#lines + 1] = '    "body": ' .. vim.json.encode(spec.body) .. ","
		lines[#lines + 1] = '    "type": ' .. vim.json.encode(spec.type) .. ","
		lines[#lines + 1] = '    "priority": ' .. tostring(spec.priority)
		lines[#lines + 1] = "  }" .. (index < #specs and "," or "")
	end
	lines[#lines + 1] = "]"
	lines[#lines + 1] = ""
	return table.concat(lines, "\n")
end

---@param specs table[]
---@return boolean, string|nil
local function save_specs(specs)
	if M.broken then
		return false, "custom.json tiene errores; corrígelo antes de guardar."
	end

	vim.fn.mkdir(snippets_dir, "p")
	local tmp = data_path .. ".tmp"

	local fd, open_err = io.open(tmp, "w")
	if not fd then
		return false, "no se pudo escribir " .. tmp .. ": " .. tostring(open_err)
	end
	local ok, write_err = fd:write(serialize(specs))
	fd:close()
	if not ok then
		os.remove(tmp)
		return false, "no se pudo escribir " .. tmp .. ": " .. tostring(write_err)
	end

	local renamed, rename_err = vim.uv.fs_rename(tmp, data_path)
	if not renamed then
		os.remove(tmp)
		return false, "no se pudo renombrar " .. tmp .. ": " .. tostring(rename_err)
	end
	return true
end

---@param specs table[]
local function register(specs)
	local by_ft = {}
	for _, spec in ipairs(specs) do
		for _, ft in ipairs(spec.filetypes) do
			local ok, snippet = pcall(build_snippet, spec)
			if ok then
				by_ft[ft] = by_ft[ft] or {}
				by_ft[ft][#by_ft[ft] + 1] = snippet
			else
				notify(("no se pudo registrar '%s': %s"):format(spec.trigger, tostring(snippet)), levels.ERROR)
			end
		end
	end

	-- La misma key reemplaza los snippets anteriores, incluidos los de
	-- filetypes que hayan desaparecido del JSON.
	ls.add_snippets(nil, by_ft, { key = add_key })
end

---Carga custom.json y registra sus snippets en LuaSnip.
---@param opts? { notify?: boolean }
---@return boolean
function M.reload(opts)
	opts = opts or {}
	local specs, err = read_specs()
	if not specs then
		M.broken = err
		notify("no se pudieron cargar los snippets: " .. err, levels.ERROR)
		-- Mantener los últimos snippets válidos si había alguno cargado.
		if #M.specs > 0 then
			register(M.specs)
		end
		return false
	end

	M.broken = nil
	M.specs = specs
	register(specs)
	if opts.notify then
		notify(("%d snippet(s) personalizado(s) recargado(s)."):format(#specs))
	end
	return true
end

-- ---------------------------------------------------------------------------
-- Asistente (corrutinas + vim.ui)
-- ---------------------------------------------------------------------------

local function resume(co, value)
	vim.schedule(function()
		local ok, err = coroutine.resume(co, value)
		if not ok then
			notify("error en el asistente: " .. tostring(err), levels.ERROR)
		end
	end)
end

---@param opts table
---@return string|nil
local function ask(opts)
	local co = coroutine.running()
	if not co then
		error("ask() fuera de una corrutina")
	end
	local answered = false
	vim.ui.input(opts, function(value)
		if answered then
			return
		end
		answered = true
		resume(co, value)
	end)
	return coroutine.yield()
end

---@param items table[]
---@param opts table
---@param format_item? fun(item: table): string
---@return table|nil
local function choose(items, opts, format_item)
	local co = coroutine.running()
	if not co then
		error("choose() fuera de una corrutina")
	end
	local answered = false
	vim.ui.select(items, {
		prompt = opts.prompt,
		format_item = format_item,
	}, function(item)
		if answered then
			return
		end
		answered = true
		resume(co, item)
	end)
	return coroutine.yield()
end

---Abre una ventana flotante para escribir el cuerpo del snippet.
---@param initial string
---@return string|nil
local function edit_body(initial)
	local co = coroutine.running()
	if not co then
		error("edit_body() fuera de una corrutina")
	end

	local buf = vim.api.nvim_create_buf(false, true)
	local lines = vim.split(initial or "", "\n", { plain = true })
	if #lines == 0 then
		lines = { "" }
	end
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_name(buf, "snippet-body-" .. buf)
	vim.bo[buf].buftype = "acwrite"
	vim.bo[buf].filetype = "text"
	vim.bo[buf].swapfile = false
	vim.bo[buf].undofile = false

	local width = math.min(math.max(20, math.floor(vim.o.columns * 0.7)), vim.o.columns)
	local height = math.min(math.max(8, math.floor(vim.o.lines * 0.6)), vim.o.lines)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.max(0, math.floor((vim.o.lines - height) / 2) - 1),
		col = math.max(0, math.floor((vim.o.columns - width) / 2)),
		style = "minimal",
		border = "rounded",
		title = " Cuerpo del snippet ",
		footer = " <C-s> guardar · q cancelar ",
	})

	vim.wo[win].wrap = true
	vim.wo[win].linebreak = true
	vim.wo[win].number = false
	vim.wo[win].relativenumber = false
	vim.wo[win].signcolumn = "no"
	vim.wo[win].foldcolumn = "0"

	local last = #lines
	vim.api.nvim_win_set_cursor(win, { last, #lines[last] })
	vim.cmd("startinsert")

	local done = false
	local function finish(value)
		if done then
			return
		end
		done = true
		vim.schedule(function()
			if vim.api.nvim_win_is_valid(win) then
				pcall(vim.api.nvim_win_close, win, true)
			end
			if vim.api.nvim_buf_is_valid(buf) then
				pcall(vim.api.nvim_buf_delete, buf, { force = true })
			end
			resume(co, value)
		end)
	end

	local function body_text()
		return table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
	end

	vim.keymap.set({ "n", "i" }, "<C-s>", function()
		finish(body_text())
	end, { buffer = buf, desc = "Guardar cuerpo del snippet" })

	vim.keymap.set("n", "q", function()
		finish(nil)
	end, { buffer = buf, desc = "Cancelar cuerpo del snippet" })

	vim.api.nvim_create_autocmd("BufWriteCmd", {
		buffer = buf,
		once = true,
		callback = function()
			finish(body_text())
		end,
	})

	local group = vim.api.nvim_create_augroup("SnippetWizardBody" .. buf, { clear = true })
	vim.api.nvim_create_autocmd("WinClosed", {
		group = group,
		pattern = tostring(win),
		once = true,
		callback = function()
			if done then
				return
			end
			done = true
			if vim.api.nvim_buf_is_valid(buf) then
				pcall(vim.api.nvim_buf_delete, buf, { force = true })
			end
			resume(co, nil)
		end,
	})

	return coroutine.yield()
end

---@param raw string
---@return string[]
local function parse_filetypes(raw)
	local result = {}
	local seen = {}
	for value in raw:gmatch("[^,%s]+") do
		value = value:lower()
		if not seen[value] then
			seen[value] = true
			result[#result + 1] = value
		end
	end
	if seen.all then
		return { "all" }
	end
	return result
end

local function join_filetypes(filetypes)
	return table.concat(filetypes, ", ")
end

---@param spec table
---@param skip_index? integer
---@return integer|nil
local function find_duplicate(spec, skip_index)
	for index, other in ipairs(M.specs) do
		if index ~= skip_index and other.trigger == spec.trigger then
			for _, a in ipairs(other.filetypes) do
				for _, b in ipairs(spec.filetypes) do
					if a == b or a == "all" or b == "all" then
						return index
					end
				end
			end
		end
	end
	return nil
end

---@param index? integer
local function run_wizard(index)
	if M.broken then
		notify("custom.json tiene errores; corrígelo antes de crear snippets.", levels.ERROR)
		return
	end

	local existing = index and M.specs[index] or nil
	if index and not existing then
		notify("ese snippet ya no existe.", levels.WARN)
		return
	end

	local co = coroutine.create(function()
		local current_ft = vim.bo.filetype ~= "" and vim.bo.filetype or "all"
		local ft_default = existing and join_filetypes(existing.filetypes) or current_ft

		local ft_raw = ask({
			prompt = "Filetype(s), separados por coma ('all' = todos): ",
			default = ft_default,
		})
		if ft_raw == nil then
			return
		end
		local filetypes = parse_filetypes(ft_raw)
		if #filetypes == 0 then
			notify("no indicaste ningún filetype.", levels.WARN)
			return
		end

		local trigger = ask({
			prompt = "Trigger: ",
			default = existing and existing.trigger or "",
		})
		if trigger == nil then
			return
		end
		trigger = vim.trim(trigger)
		if trigger == "" then
			notify("el trigger no puede estar vacío.", levels.WARN)
			return
		end
		if trigger:find("%s") then
			notify("el trigger no puede contener espacios.", levels.WARN)
			return
		end

		local description = ask({
			prompt = "Descripción (opcional): ",
			default = existing and existing.description or "",
		})
		if description == nil then
			return
		end
		description = vim.trim(description)
		if description == "" then
			description = trigger
		end

		local body = edit_body(existing and existing.body or "")
		if body == nil then
			return
		end
		if body == "" then
			notify("el cuerpo no puede estar vacío.", levels.WARN)
			return
		end

		local kind_items = { "Snippet normal", "Autosnippet" }
		if existing and existing.type == "autosnippet" then
			kind_items = { "Autosnippet", "Snippet normal" }
		end
		local kind_choice = choose(kind_items, { prompt = "Tipo de snippet: " }, function(item)
			return item
		end)
		if kind_choice == nil then
			return
		end
		local kind = kind_choice == "Autosnippet" and "autosnippet" or "snippet"

		local spec = {
			filetypes = filetypes,
			trigger = trigger,
			description = description,
			body = body,
			type = kind,
			priority = default_priority,
		}

		local ok_parse, parse_err = pcall(build_snippet, spec)
		if not ok_parse then
			notify("el cuerpo no es un snippet LSP válido: " .. tostring(parse_err), levels.ERROR)
			return
		end

		local previous = vim.deepcopy(M.specs)
		local duplicate = find_duplicate(spec, index)
		if duplicate then
			local choice = choose({ "Sí, reemplazar", "No, cancelar" }, {
				prompt = ("Ya existe '%s' para %s. ¿Reemplazarlo?"):format(
					M.specs[duplicate].trigger,
					join_filetypes(M.specs[duplicate].filetypes)
				),
			})
			if choice ~= "Sí, reemplazar" then
				return
			end
			M.specs[duplicate] = spec
			if index and index ~= duplicate then
				table.remove(M.specs, index)
			end
		elseif index then
			M.specs[index] = spec
		else
			M.specs[#M.specs + 1] = spec
		end

		local ok_save, save_err = save_specs(M.specs)
		if not ok_save then
			M.specs = previous
			notify(save_err, levels.ERROR)
			return
		end

		register(M.specs)
		notify(
			("snippet '%s' %s para %s."):format(
				trigger,
				existing and "actualizado" or "guardado",
				join_filetypes(filetypes)
			)
		)
	end)

	local ok, err = coroutine.resume(co)
	if not ok then
		notify("error en el asistente: " .. tostring(err), levels.ERROR)
	end
end

local function manage()
	if M.broken then
		notify("custom.json tiene errores; corrígelo antes de editar snippets.", levels.ERROR)
		return
	end
	if #M.specs == 0 then
		notify("no hay snippets personalizados. Usa :SnippetNew para crear uno.")
		return
	end

	local co = coroutine.create(function()
		local items = {}
		for index, spec in ipairs(M.specs) do
			items[#items + 1] = { index = index, spec = spec }
		end

		local chosen = choose(items, { prompt = "Snippet personalizado: " }, function(item)
			return ("[%s] %s — %s (%s)"):format(
				join_filetypes(item.spec.filetypes),
				item.spec.trigger,
				item.spec.description,
				item.spec.type == "autosnippet" and "auto" or "normal"
			)
		end)
		if not chosen then
			return
		end

		local action = choose({ "Editar", "Eliminar", "Cancelar" }, {
			prompt = ("%s: %s"):format(chosen.spec.trigger, chosen.spec.description),
		})
		if action == "Editar" then
			run_wizard(chosen.index)
		elseif action == "Eliminar" then
			local confirm = choose({ "Sí, eliminar", "No, cancelar" }, {
				prompt = ("¿Eliminar '%s' para %s?"):format(
					chosen.spec.trigger,
					join_filetypes(chosen.spec.filetypes)
				),
			})
			if confirm ~= "Sí, eliminar" then
				return
			end

			local previous = vim.deepcopy(M.specs)
			table.remove(M.specs, chosen.index)
			local ok, err = save_specs(M.specs)
			if not ok then
				M.specs = previous
				notify(err, levels.ERROR)
				return
			end

			register(M.specs)
			notify(("snippet '%s' eliminado."):format(chosen.spec.trigger))
		end
	end)

	local ok, err = coroutine.resume(co)
	if not ok then
		notify("error en el asistente: " .. tostring(err), levels.ERROR)
	end
end

function M.setup()
	vim.fn.mkdir(snippets_dir, "p")
	M.reload()

	vim.api.nvim_create_user_command("SnippetNew", function()
		run_wizard(nil)
	end, { desc = "Crear un snippet personalizado con un asistente", force = true })

	vim.api.nvim_create_user_command("SnippetList", function()
		manage()
	end, { desc = "Listar, editar o eliminar snippets personalizados", force = true })

	vim.api.nvim_create_user_command("SnippetReload", function()
		M.reload({ notify = true })
	end, { desc = "Recargar snippets personalizados desde custom.json", force = true })

	vim.api.nvim_create_autocmd("BufWritePost", {
		group = vim.api.nvim_create_augroup("SnippetWizardJson", { clear = true }),
		pattern = "custom.json",
		callback = function(args)
			if same_path(vim.api.nvim_buf_get_name(args.buf), data_path) then
				M.reload({ notify = true })
			end
		end,
	})
end

M.setup()

return M

-- nvim-treesitter (rama `main`).
-- En esta versión `setup` solo acepta `install_dir`; highlight, indent y la
-- instalación de parsers se configuran aparte.

local ts_langs = {
	"python",
	"lua",
	"bash",
	"c",
	"cpp",
	"html",
	"asm",
	"sql",
	"rust",
	"java",
	"go",
	"xml",
	-- Bibliotecas de Go
	-- "scheme",
	-- "diff",
	-- "luadoc",
}

require("nvim-treesitter").setup({
	-- Carpeta base: aquí se crean parser/, queries/ y parser-info/
	install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site"),
})

-- Instala en segundo plano los parsers que falten (no-op si ya están)
vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		require("nvim-treesitter").install(ts_langs)
	end,
})

-- Resalta, indenta y pliega con tree-sitter en los buffers con parser
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local buf = args.buf
		if not pcall(vim.treesitter.start, buf) then
			return -- sin parser: se mantiene el syntax de Neovim
		end
		vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		vim.bo[buf].syntax = "" -- evita el doble resaltado del syntax clásico
	end,
})

-- LSP: Mason, servidores y diagnósticos.

require("mason").setup({})
require("mason-lspconfig").setup()

require("mason-tool-installer").setup({
	ensure_installed = {
		"pyright",
		"lua_ls",
		"stylua",
		"tinymist",
		"rust-analyzer",
		"gopls",
		"jdtls",
		"google-java-format",
		"java-debug-adapter",
		"java-test",
		"goimports",
		-- clangd y clang-format se usan del sistema (/usr/bin/...), no desde
		-- Mason: ya están instalados y el paquete de clang-format falla al
		-- instalarse en este equipo.
	},
})

vim.lsp.enable({ "lua_ls", "pyright", "tinymist", "rust-analyzer", "gopls", "clangd" })

-- Keymaps LSP genéricos (solo en buffers con servidor adjunto)
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local function map(keys, fn, desc)
			vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
		end
		map("gd", vim.lsp.buf.definition, "ir a definición")
		map("K", vim.lsp.buf.hover, "hover")
		map("gr", vim.lsp.buf.references, "referencias")
		map("<leader>rn", vim.lsp.buf.rename, "renombrar")
	end,
})

vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = { min = vim.diagnostic.severity.WARN } },

	virtual_text = true, -- Texto al final de la línea
	virtual_lines = false, -- Texto debajo de la línea, con virtual lines

	-- Abre el float al saltar con `[d` y `]d`
	jump = {
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({
				bufnr = bufnr,
				scope = "cursor",
				focus = false,
			})
		end,
	},
})

require("conform").setup({
	notify_on_error = false,
	format_on_save = function(bufnr)
		-- No autoformatear archivos descomunalmente grandes
		if vim.api.nvim_buf_line_count(bufnr) > 100000 then
			return nil
		end
		return { timeout_ms = 3000 }
	end,
	default_format_opts = {
		-- Usa formateadores externos si están configurados; si no, LSP.
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		lua = { "stylua" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		java = { "google-java-format" },
		go = { "goimports", "gofmt", stop_after_first = true },
		-- Conform puede ejecutar varios formateadores en secuencia
		-- python = { "isort", "black" },
		-- javascript = { "prettierd", "prettier", stop_after_first = true },
	},
})

vim.keymap.set({ "n", "v" }, "<C-s>", function()
	require("conform").format({ async = false, timeout_ms = 500, lsp_format = "fallback" })
	vim.cmd("write")
end, { desc = "[F]ormat + guardar buffer" })

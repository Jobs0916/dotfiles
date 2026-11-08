-- Java: jdtls arrancado por proyecto con nvim-jdtls.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function(ev)
		local root = vim.fs.root(ev.buf, { "gradlew", "mvnw", "pom.xml", "build.gradle", ".git" })
		local mason = vim.fn.stdpath("data") .. "/mason/packages"

		local bundles = {}
		for _, pkg in ipairs({ "java-debug-adapter", "java-test" }) do
			vim.list_extend(bundles, vim.fn.glob(mason .. "/" .. pkg .. "/**/com.*.jar", false, true))
		end

		require("jdtls").start_or_attach({
			cmd = { mason .. "/jdtls/bin/jdtls" },
			root_dir = root,
			data = vim.fn.stdpath("cache") .. "/jdtls_" .. (root and vim.fn.fnamemodify(root, ":t") or "root"),
			bundles = bundles,
			on_attach = function(_, bufnr)
				local map = function(keys, fn, desc)
					vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = "Java: " .. desc })
				end
				map("<leader>jo", function()
					require("jdtls").organize_imports()
				end, "organizar imports")
				map("<leader>jt", function()
					require("jdtls").test_class()
				end, "test de clase")
				map("<leader>jr", function()
					require("jdtls").restart_frame()
				end, "restart frame")
			end,
		})
	end,
})

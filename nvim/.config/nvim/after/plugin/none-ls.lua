local null_ls = require("null-ls")
local mason_null_ls = require("mason-null-ls")

mason_null_ls.setup({
	ensure_installed = {
		"stylua",
		"black",
		"prettier"
	}
})

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.prettier,
	},
	vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, {}),
})

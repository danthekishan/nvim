return {
	"L3MON4D3/LuaSnip",
	build = (function()
		-- Build Step is needed for regex support in snippets
		-- This step is not supported in many windows environments
		-- Remove the below condition to re-enable on windows
		if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
			return
		end
		return "make install_jsregexp"
	end)(),
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	config = function(_, opts)
		local ls = require("luasnip")
		if opts then
			ls.config.setup(opts)
		end
		vim.tbl_map(function(type)
			require("luasnip.loaders.from_" .. type).lazy_load()
		end, { "vscode", "snipmate", "lua" })
		-- friendly-snippets - enable standardized comments snippets
		ls.filetype_extend("typescript", { "tsdoc" })
		ls.filetype_extend("javascript", { "jsdoc", "next", "react" })
		ls.filetype_extend("javascriptreact", { "html", "css" })
		ls.filetype_extend("typescriptreact", { "html", "css" })
		ls.filetype_extend("lua", { "luadoc" })
		ls.filetype_extend("python", { "pydoc" })
		ls.filetype_extend("rust", { "rustdoc" })

		require("../config.snippets")

		-- jump forward within snippet
		vim.keymap.set({ "i" }, "<C-k>", function()
			ls.expand()
		end, { silent = true })
		vim.keymap.set({ "i", "s" }, "<C-l>", function()
			ls.jump(1)
		end, { silent = true })
		vim.keymap.set({ "i", "s" }, "<C-h>", function()
			ls.jump(-1)
		end, { silent = true })
		vim.keymap.set({ "i", "s" }, "<C-E>", function()
			if ls.choice_active() then
				ls.change_choice(1)
			end
		end, { silent = true })
		vim.keymap.set("n", "<leader>xs", "<cmd>source ~/.config/nvim/lua/config/snippets.lua<CR>")
	end,
}

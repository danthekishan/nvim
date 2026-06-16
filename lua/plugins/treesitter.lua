return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local ensure_installed = {
			"bash",
			"c",
			"css",
			"dockerfile",
			"eex",
			"elixir",
			"gitignore",
			"go",
			"gomod",
			"gosum",
			"gowork",
			"heex",
			"html",
			"javascript",
			"json",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"python",
			"query",
			"rust",
			"solidity",
			"svelte",
			"toml",
			"typescript",
			"vim",
			"vimdoc",
			"vue",
			"yaml",
		}

		require("nvim-treesitter").install(ensure_installed)

		-- Start treesitter highlighting (and indentation) whenever a parser
		-- is available for the buffer's filetype. The `main` branch no longer
		-- enables this via opts -- it must be started per-buffer.
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
			callback = function(args)
				local ft = vim.bo[args.buf].filetype
				local lang = vim.treesitter.language.get_lang(ft)
				if not (lang and vim.treesitter.language.add(lang)) then
					return
				end
				vim.treesitter.start(args.buf, lang)
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}

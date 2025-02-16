local config = function()
	require("nvim-treesitter.configs").setup({
		build = ":TSUpdate",
		indent = {
			enable = true,
		},
		autotag = {
			enable = true,
		},
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		ensure_installed = {
			"elixir",
			"eex",
			"heex",
			"vimdoc",
			"luadoc",
			"vim",
			"query",
			"go",
			"gomod",
			"gowork",
			"gosum",
			"markdown",
			"json",
			"javascript",
			"typescript",
			"yaml",
			"html",
			"css",
			"markdown",
			"bash",
			"lua",
			"dockerfile",
			"solidity",
			"gitignore",
			"python",
			"vue",
			"svelte",
			"toml",
		},
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = true,
		},
	})
end

return {
	"nvim-treesitter/nvim-treesitter",
	-- lazy = false,
	event = { "BufReadPost", "BufNewFile" },
	config = config,
}

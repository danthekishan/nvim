return {
	"folke/trouble.nvim",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = { use_diagnostic_signs = true },
}

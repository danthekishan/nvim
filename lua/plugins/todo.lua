return {
	"folke/todo-comments.nvim",
	cmd = { "TodoTrouble", "TodoTelescope" },
	config = true,
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
}

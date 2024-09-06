local home = vim.fn.expand("$HOME")

return {
	"jackMort/ChatGPT.nvim",
	event = "VeryLazy",
	config = function()
		require("chatgpt").setup({
			api_key_cmd = "gpg --decrypt " .. home .. "/openai.gpg",
			openai_params = {
				model = "gpt-4",
				frequency_penalty = 0,
				presence_penalty = 0,
				max_tokens = 4096,
				temperature = 0,
				top_p = 1,
				n = 1,
			},
			openai_edit_params = {
				model = "gpt-4",
				frequency_penalty = 0,
				presence_penalty = 0,
				temperature = 0,
				top_p = 1,
				n = 1,
			},
		})
	end,
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"folke/trouble.nvim",
		"nvim-telescope/telescope.nvim",
	},
}

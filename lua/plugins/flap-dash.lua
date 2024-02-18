return {
	dir = "~/learn/flap-dash-nvim",
	event = "VeryLazy",
	config = function()
		require("flap-dash").setup({
			name = "Dan",
		})
	end,
}

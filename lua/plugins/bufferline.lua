return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("bufferline").setup({
			options = {
				mode = "buffers",
				numbers = "none",
				close_command = function(bufnr)
					require("mini.bufremove").delete(bufnr, false)
				end,
				indicator = { style = "icon", icon = "▎" },
				buffer_close_icon = "󰅖",
				modified_icon = "●",
				close_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",
				max_name_length = 18,
				max_prefix_length = 15,
				tab_size = 18,
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(_, _, diag)
					local icons = { error = " ", warning = " ", info = " " }
					local ret = (diag.error and icons.error .. diag.error .. " " or "")
						.. (diag.warning and icons.warning .. diag.warning or "")
					return vim.trim(ret)
				end,
				separator_style = "thin",
				always_show_bufferline = true,
			},
		})
	end,
}

return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = {
		options = {
			icons_enabled = true,
			theme = "catppuccin",
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = { statusline = { "dashboard", "lazy" } },
			globalstatus = true,
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch" },
			lualine_c = { { "filename", path = 1 } },
			lualine_x = {
				"fileformat",
				"filetype",
			},
			lualine_y = { "progress" },
			lualine_z = {
				{
					"diagnostics",
					-- Table of diagnostic sources, available sources are:
					sources = { "nvim_lsp", "nvim_diagnostic", "coc" },
					-- Displays diagnostics for the defined severity types
					sections = { "error", "warn", "info", "hint" },
					diagnostics_color = {
						-- Same values as the general color option can be used here.
						error = "DiagnosticError", -- Changes diagnostics' error color.
						warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
						info = "DiagnosticInfo", -- Changes diagnostics' info color.
						hint = "DiagnosticHint", -- Changes diagnostics' hint color.
					},
					symbols = { error = "E", warn = "W", info = "I", hint = "H" },
					colored = true, -- Displays diagnostics status in color if set to true.
					update_in_insert = false, -- Update diagnostics in insert mode.
					always_visible = false, -- Show diagnostics even if there are none.
				},
			},
		},
	},
}

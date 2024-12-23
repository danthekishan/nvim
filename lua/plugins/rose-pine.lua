return {
	"rose-pine/neovim",
	name = "rose-pine",
	lazy = false,
	config = function()
		require("rose-pine").setup({
			variant = "auto", -- auto, main, moon, or dawn
			dark_variant = "moon", -- main, moon, or dawn
			dim_inactive_windows = false,
			extend_background_behind_borders = true,
			styles = {
				transparency = false,
			},
			highlight_groups = {
				CurSearch = { fg = "base", bg = "leaf", inherit = false },
				Search = { fg = "text", bg = "leaf", blend = 20, inherit = false },
				TelescopeBorder = { fg = "overlay", bg = "overlay" },
				TelescopeNormal = { fg = "subtle", bg = "overlay" },
				TelescopeSelection = { fg = "text", bg = "highlight_med" },
				TelescopeSelectionCaret = { fg = "love", bg = "highlight_med" },
				TelescopeMultiSelection = { fg = "text", bg = "highlight_high" },

				TelescopeTitle = { fg = "base", bg = "love" },
				TelescopePromptTitle = { fg = "base", bg = "pine" },
				TelescopePreviewTitle = { fg = "base", bg = "iris" },

				TelescopePromptNormal = { fg = "text", bg = "surface" },
				TelescopePromptBorder = { fg = "surface", bg = "surface" },
			},
		})
		vim.cmd("colorscheme rose-pine")
	end,
}

return {
	"sainnhe/gruvbox-material",
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.gruvbox_material_background = "medium"
		vim.g.gruvbox_material_foreground = "material"
		vim.g.gruvbox_material_enable_italic = 1
		vim.g.gruvbox_material_better_performance = 1
		vim.g.gruvbox_material_transparent_background = 1
		vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
		vim.g.gruvbox_material_inlay_hints_background = "dimmed"
		vim.g.gruvbox_material_float_style = "dim"
		vim.g.gruvbox_material_ui_contrast = "low"

		vim.cmd.colorscheme("gruvbox-material")
	end,
}

-- return {
-- 	"rose-pine/neovim",
-- 	name = "rose-pine",
-- 	lazy = false,
-- 	config = function()
-- 		require("rose-pine").setup({
-- 			variant = "auto", -- auto, main, moon, or dawn
-- 			dark_variant = "moon", -- main, moon, or dawn
-- 			dim_inactive_windows = false,
-- 			extend_background_behind_borders = true,
-- 			styles = {
-- 				transparency = false,
-- 			},
-- 			highlight_groups = {
-- 				CurSearch = { fg = "base", bg = "leaf", inherit = false },
-- 				Search = { fg = "text", bg = "leaf", blend = 20, inherit = false },
-- 			},
-- 		})
-- 		vim.cmd("colorscheme rose-pine")
-- 	end,
-- }

-- return {
-- 	"catppuccin/nvim",
-- 	enabled = false,
-- 	lazy = false,
-- 	name = "catppuccin",
-- 	priority = 1000,
-- 	config = function()
-- 		require("catppuccin").setup({
-- 			flavour = "macchiato", -- latte, frappe, macchiato, mocha
-- 			background = { -- :h background
-- 				light = "latte",
-- 				dark = "macchiato",
-- 			},
-- 			transparent_background = true, -- disables setting the background color.
-- 			show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
-- 			term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
-- 			dim_inactive = {
-- 				enabled = false, -- dims the background color of inactive window
-- 				shade = "dark",
-- 				percentage = 0.10, -- percentage of the shade to apply to the inactive window
-- 			},
-- 			no_italic = false, -- Force no italic
-- 			no_bold = false, -- Force no bold
-- 			no_underline = false, -- Force no underline
-- 			styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
-- 				comments = { "italic" }, -- Change the style of comments
-- 				conditionals = { "italic" },
-- 				loops = {},
-- 				functions = {},
-- 				keywords = {},
-- 				strings = {},
-- 				variables = {},
-- 				numbers = {},
-- 				booleans = {},
-- 				properties = {},
-- 				types = {},
-- 				operators = {},
-- 				-- miscs = {}, -- Uncomment to turn off hard-coded styles
-- 			},
-- 			color_overrides = {},
-- 			custom_highlights = {},
-- 			default_integrations = true,
-- 			integrations = {
-- 				snacks = true,
-- 				blink_cmp = true,
-- 				gitsigns = true,
-- 				harpoon = true,
-- 				treesitter = true,
-- 				notify = false,
-- 				mini = {
-- 					enabled = true,
-- 					indentscope_color = "",
-- 				},
-- 				-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
-- 			},
-- 		})
--
-- 		-- setup must be called before loading
-- 		vim.cmd.colorscheme("catppuccin")
-- 	end,
-- }

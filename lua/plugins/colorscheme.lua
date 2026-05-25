return {
	"catppuccin/nvim",
	lazy = false,
	priority = 1000,
	name = "catppuccin",
	config = function()
		require("catppuccin").setup({
			flavour = "macchiato",
			background = { light = "latte", dark = "macchiato" },
			transparent_background = true,
			show_end_of_buffer = false,
			term_colors = false,
			dim_inactive = { enabled = false, shade = "dark", percentage = 0.10 },
			no_italic = false,
			no_bold = false,
			no_underline = false,
			styles = {
				comments = { "italic" },
				conditionals = { "italic" },
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
				operators = {},
			},
			color_overrides = {
				macchiato = {
					red = "#c26278",
					orange = "#d4826a",
					yellow = "#d4b87a",
					green = "#6daf80",
					teal = "#5caaaa",
					blue = "#6a8fd8",
					sky = "#5caacb",
					lavender = "#8c8cc2",
					mauve = "#a06fa0",
					pink = "#c26e8a",
					flamingo = "#c2788a",
					rosewater = "#c4a0a0",
				},
			},
			custom_highlights = function(colors)
				return {
					NormalFloat = { bg = "#10111a" },
					FloatBorder = { fg = colors.surface0, bg = "#10111a" },
					Visual = { bg = "#1e1f30" },
					VisualLine = { bg = "#1e1f30" },
					Search = { fg = colors.text, bg = "#1e1f30" },
					IncSearch = { fg = colors.text, bg = "#2a2b40" },
					CurSearch = { fg = colors.text, bg = "#2a2b40" },
					CursorLine = { bg = "#141522" },
					CursorLineNr = { fg = colors.subtext1, bg = "#141522" },
					CursorColumn = { bg = "#141522" },
					ColorColumn = { bg = "#141522" },
					MatchParen = { fg = colors.peach, bg = "#1e1f30" },
					Pmenu = { bg = "#10111a" },
					PmenuSel = { bg = "#1e1f30" },
					PmenuSbar = { bg = "#141522" },
					PmenuThumb = { bg = colors.surface0 },
					WinBar = { bg = "#10111a" },
					WinBarNC = { bg = "#10111a" },
					StatusLine = { bg = "#10111a" },
					StatusLineNC = { bg = "#10111a" },
					SignColumn = { bg = "NONE" },
					FoldColumn = { bg = "NONE" },
					LineNr = { fg = colors.surface1, bg = "NONE" },
					EndOfBuffer = { fg = colors.surface0 },
									IndentGuide = { fg = colors.surface0 },
					MiniIndentscopeSymbol = { fg = colors.surface0 },
					MiniIndentscopeSymbolOff = { fg = colors.surface0 },
					LspReferenceText = { bg = "#1a1b2e" },
					LspReferenceRead = { bg = "#1a1b2e" },
					LspReferenceWrite = { bg = "#1e1f30" },
					LspReferenceTarget = { bg = "#1a1b2e" },
					BlinkCmpMenu = { bg = "#10111a" },
					BlinkCmpMenuBorder = { bg = "#10111a", fg = colors.surface0 },
					BlinkCmpMenuSelection = { bg = "#1e1f30" },
					BlinkCmpLabel = { fg = colors.text },
					BlinkCmpLabelMatch = { fg = colors.subtext0, bold = true },
					BlinkCmpLabelDetail = { fg = colors.subtext1 },
					BlinkCmpLabelDescription = { fg = colors.overlay0 },
					BlinkCmpKind = { fg = colors.subtext0 },
					BlinkCmpKindFunction = { fg = colors.blue },
					BlinkCmpKindMethod = { fg = colors.blue },
					BlinkCmpKindVariable = { fg = colors.flamingo },
					BlinkCmpKindConstant = { fg = colors.peach },
					BlinkCmpKindClass = { fg = colors.mauve },
					BlinkCmpKindInterface = { fg = colors.mauve },
					BlinkCmpKindModule = { fg = colors.lavender },
					BlinkCmpKindProperty = { fg = colors.teal },
					BlinkCmpKindField = { fg = colors.teal },
					BlinkCmpKindConstructor = { fg = colors.sapphire },
					BlinkCmpKindEnum = { fg = colors.mauve },
					BlinkCmpKindEnumMember = { fg = colors.peach },
					BlinkCmpKindKeyword = { fg = colors.mauve },
					BlinkCmpKindTypeParameter = { fg = colors.mauve },
					BlinkCmpKindSnippet = { fg = colors.green },
					BlinkCmpKindFile = { fg = colors.yellow },
					BlinkCmpKindFolder = { fg = colors.yellow },
					BlinkCmpKindText = { fg = colors.subtext0 },
					BlinkCmpKindEvent = { fg = colors.peach },
					BlinkCmpKindOperator = { fg = colors.sky },
					BlinkCmpKindUnit = { fg = colors.peach },
					BlinkCmpKindValue = { fg = colors.peach },
					BlinkCmpSource = { fg = colors.overlay0 },
					BlinkCmpDoc = { bg = "#10111a" },
					BlinkCmpDocBorder = { bg = "#10111a", fg = colors.surface0 },
					BlinkCmpDocCursorLine = { bg = "#1e1f30" },
					BlinkCmpGhostText = { fg = colors.overlay0 },
					BlinkCmpSignatureHelp = { bg = "#10111a" },
					BlinkCmpSignatureHelpBorder = { bg = "#10111a", fg = colors.surface0 },
					BlinkCmpSignatureHelpActiveParameter = { fg = colors.peach, bold = true },
				}
			end,
			default_integrations = true,
			integrations = {
				snacks = true,
				blink_cmp = true,
				gitsigns = true,
				harpoon = true,
				treesitter = true,
				notify = false,
				mini = { enabled = true, indentscope_color = "" },
			},
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}

-- return {
-- 	"sainnhe/gruvbox-material",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		vim.g.gruvbox_material_background = "medium"
-- 		vim.g.gruvbox_material_foreground = "material"
-- 		vim.g.gruvbox_material_enable_italic = 1
-- 		vim.g.gruvbox_material_better_performance = 1
-- 		vim.g.gruvbox_material_transparent_background = 1
-- 		vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
-- 		vim.g.gruvbox_material_inlay_hints_background = "dimmed"
-- 		vim.g.gruvbox_material_float_style = "dim"
-- 		vim.g.gruvbox_material_ui_contrast = "low"
-- 		vim.cmd.colorscheme("gruvbox-material")
-- 	end,
-- }

-- return {
-- 	"rose-pine/neovim",
-- 	name = "rose-pine",
-- 	lazy = false,
-- 	config = function()
-- 		require("rose-pine").setup({
-- 			variant = "auto",
-- 			dark_variant = "moon",
-- 			dim_inactive_windows = false,
-- 			extend_background_behind_borders = true,
-- 			styles = { transparency = false },
-- 			highlight_groups = {
-- 				CurSearch = { fg = "base", bg = "leaf", inherit = false },
-- 				Search = { fg = "text", bg = "leaf", blend = 20, inherit = false },
-- 			},
-- 		})
-- 		vim.cmd("colorscheme rose-pine")
-- 	end,
-- }

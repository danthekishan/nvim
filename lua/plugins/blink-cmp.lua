return {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"L3MON4D3/LuaSnip",
	},

	version = "*",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "default",
			["<C-n>"] = { "select_next", "snippet_forward", "fallback" },
			["<C-p>"] = { "select_prev", "snippet_backward", "fallback" },
			["<Tab>"] = { "accept", "fallback" },
			["<S-Tab>"] = { "fallback" },
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
				treesitter_highlighting = true,
				window = {
					min_width = 10,
					max_width = 80,
					max_height = 20,
					border = "rounded",
					-- winblend = 10,
					-- winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine",
					scrollbar = true,
				},
			},
			menu = {
				border = "rounded",
				winblend = 10,
				winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
				draw = {
					treesitter = { "lsp" },
					padding = 1,
					gap = 1,
					columns = {
						{ "kind_icon" },
						{ "label", "label_description", gap = 1 },
						{ "kind" },
					},
				},
			},
			ghost_text = {
				enabled = true,
			},
		},

		snippets = {
			preset = "luasnip",
			expand = function(snippet)
				require("luasnip").lsp_expand(snippet)
			end,
			active = function(filter)
				local luasnip = require("luasnip")
				if filter and filter.direction then
					return luasnip.jumpable(filter.direction)
				end
				return luasnip.in_snippet()
			end,
			jump = function(direction)
				local luasnip = require("luasnip")
				if luasnip.jumpable(direction) then
					luasnip.jump(direction)
				end
			end,
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		signature = {
			enabled = true,
			-- window = {
			-- 	min_width = 1,
			-- 	max_width = 100,
			-- 	max_height = 10,
			-- 	border = "rounded",
			-- 	scrollbar = true,
			-- 	winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
			-- 	show_documentation = false,
			-- },
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
-- return {
-- 	"saghen/blink.cmp",
-- 	event = "InsertEnter",
-- 	dependencies = {
-- 		"moyiz/blink-emoji.nvim",
-- 		"rafamadriz/friendly-snippets",
-- 		{
-- 			"Saecki/crates.nvim",
-- 			event = { "BufRead Cargo.toml" },
-- 			opts = {},
-- 		},
-- 		{ -- Ensure LuaSnip is explicitly included and configured
-- 			"L3MON4D3/LuaSnip",
-- 			version = "v2.*",
-- 			config = function()
-- 				require("luasnip.loaders.from_vscode").lazy_load() -- Load friendly-snippets
-- 			end,
-- 		},
-- 	},
-- 	version = "*",
--
-- 	---@module 'blink.cmp'
-- 	---@type blink.cmp.Config
-- 	opts = {
-- 		keymap = { preset = "default" },
--
-- 		appearance = {
-- 			use_nvim_cmp_as_default = true,
-- 			nerd_font_variant = "mono",
-- 		},
--
-- 		snippets = {
-- 			preset = "luasnip",
-- 			expand = function(snippet)
-- 				require("luasnip").lsp_expand(snippet)
-- 			end,
-- 			active = function(filter)
-- 				if filter and filter.direction then
-- 					return require("luasnip").jumpable(filter.direction)
-- 				end
-- 				return require("luasnip").in_snippet()
-- 			end,
-- 			jump = function(direction)
-- 				require("luasnip").jump(direction)
-- 			end,
-- 		},
--
-- 		completion = {
-- 			documentation = {
-- 				auto_show = true,
-- 				auto_show_delay_ms = 200,
-- 			},
-- 			ghost_text = { enabled = false },
-- 		},
--
-- 		sources = {
-- 			default = { "lsp", "path", "snippets", "buffer", "emoji" },
-- 			providers = {
-- 				lsp = {
-- 					name = "lsp",
-- 					enabled = true,
-- 					module = "blink.cmp.sources.lsp",
-- 				},
-- 				path = {
-- 					name = "Path",
-- 					module = "blink.cmp.sources.path",
-- 					opts = {
-- 						trailing_slash = false,
-- 						label_trailing_slash = true,
-- 						get_cwd = function(context)
-- 							return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
-- 						end,
-- 						show_hidden_files_by_default = true,
-- 					},
-- 				},
-- 				buffer = {
-- 					name = "Buffer",
-- 					enabled = true,
-- 					max_items = 3,
-- 					module = "blink.cmp.sources.buffer",
-- 					min_keyword_length = 4,
-- 				},
-- 				snippets = {
-- 					name = "snippets",
-- 					enabled = true,
-- 					max_items = 8,
-- 					min_keyword_length = 2,
-- 					module = "blink.cmp.sources.snippets",
-- 				},
-- 				emoji = {
-- 					module = "blink-emoji",
-- 					name = "Emoji",
-- 					opts = { insert = true },
-- 				},
-- 			},
-- 		},
--
-- 		signature = { enabled = true },
-- 	},
-- }

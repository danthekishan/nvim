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
		keymap = { preset = "default" },

		appearance = {
			nerd_font_variant = "mono",
		},

		snippets = { preset = "luasnip" },

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
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

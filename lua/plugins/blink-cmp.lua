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
					border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
					scrollbar = true,
					winblend = 15,
				},
			},
			menu = {
				border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
				winblend = 15,
				draw = {
					treesitter = { "lsp" },
					padding = 2,
					gap = 1,
					columns = {
						{ "kind_icon", gap = 1 },
						{ "label", "label_description", gap = 1 },
					},
				},
			},
			ghost_text = {
				enabled = false,
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
			window = {
				min_width = 1,
				max_width = 80,
				max_height = 10,
				border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
				scrollbar = true,
				winblend = 15,
			},
		},

		fuzzy = { implementation = "prefer_rust" },
	},
	opts_extend = { "sources.default" },
}

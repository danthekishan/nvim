return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = { "rafamadriz/friendly-snippets" },

	-- use a release tag to download pre-built binaries
	version = "*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
		-- 'super-tab' for mappings similar to vscode (tab to accept)
		-- 'enter' for enter to accept
		-- 'none' for no mappings
		--
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		--
		-- See :h blink-cmp-config-keymap for defining your own keymap
		keymap = { preset = "default" },

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
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

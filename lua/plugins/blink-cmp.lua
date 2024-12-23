-- return {
-- 	{
-- 		"hrsh7th/nvim-cmp",
-- 		event = "InsertEnter", -- Lazy load on entering insert mode
-- 		dependencies = {
-- 			"hrsh7th/cmp-nvim-lsp",
-- 			"hrsh7th/cmp-buffer",
-- 			"hrsh7th/cmp-path",
-- 			"L3MON4D3/LuaSnip",
-- 			"saadparwaiz1/cmp_luasnip",
-- 			{
-- 				"Saecki/crates.nvim",
-- 				event = { "BufRead Cargo.toml" },
-- 				opts = {
-- 					completion = {
-- 						cmp = { enabled = true },
-- 					},
-- 				},
-- 			},
-- 		},
--
-- 		config = function()
-- 			-- vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
-- 			local cmp = require("cmp")
-- 			local luasnip = require("luasnip")
-- 			local options = {
--
-- 				-- Snippet engine configuration
-- 				snippet = {
-- 					expand = function(args)
-- 						require("luasnip").lsp_expand(args.body)
-- 					end,
-- 				},
--
-- 				completion = { completeopt = "menu,menuone,noinsert" },
--
-- 				-- ghost text
-- 				experimental = { ghost_text = true },
--
-- 				-- window
-- 				window = {
-- 					completion = cmp.config.window.bordered(),
-- 					documentation = cmp.config.window.bordered(),
-- 				},
--
-- 				mapping = cmp.mapping.preset.insert({
--
-- 					["<C-n>"] = cmp.mapping.select_next_item(),
-- 					["<C-p>"] = cmp.mapping.select_prev_item(),
-- 					["<C-b>"] = cmp.mapping.scroll_docs(-4),
-- 					["<C-f>"] = cmp.mapping.scroll_docs(4),
-- 					["<C-y>"] = cmp.mapping.confirm({ select = true }),
--
-- 					-- Manually trigger a completion from nvim-cmp.
-- 					--  Generally you don't need this, because nvim-cmp will display
-- 					--  completions whenever it has completion options available.
-- 					["<C-Space>"] = cmp.mapping.complete({}),
--
-- 					-- <c-l> will move you to the right of each of the expansion locations.
-- 					-- <c-h> is similar, except moving you backwards.
-- 					["<C-l>"] = cmp.mapping(function()
-- 						if luasnip.expand_or_locally_jumpable() then
-- 							luasnip.expand_or_jump()
-- 						end
-- 					end, { "i", "s" }),
-- 					["<C-h>"] = cmp.mapping(function()
-- 						if luasnip.locally_jumpable(-1) then
-- 							luasnip.jump(-1)
-- 						end
-- 					end, { "i", "s" }),
-- 				}),
--
-- 				-- sources
-- 				sources = cmp.config.sources({
-- 					{ name = "nvim_lsp" },
-- 					{ name = "luasnip" },
-- 					{ name = "buffer" },
-- 					{ name = "lazydev", group_index = 0 },
-- 					{ name = "path" },
-- 				}),
-- 			}
--
-- 			-- `/` cmdline setup.
-- 			cmp.setup.cmdline("/", {
-- 				mapping = cmp.mapping.preset.cmdline(),
-- 				sources = {
-- 					{ name = "buffer" },
-- 				},
-- 			})
--
-- 			cmp.setup(options)
-- 		end,
-- 	},
-- }

return {
	"saghen/blink.cmp",
	event = "InsertEnter",
	-- optional: provides snippets for the snippet source
	dependencies = {
		"rafamadriz/friendly-snippets",
		{
			"Saecki/crates.nvim",
			event = { "BufRead Cargo.toml" },
			opts = {
				completion = {
					cmp = { enabled = true },
				},
			},
		},
	},
	version = "*",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = { preset = "default" },

		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},

		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},
			ghost_text = { enabled = true },
		},

		signature = { enabled = true },
	},
	opts_extend = { "sources.default" },
}

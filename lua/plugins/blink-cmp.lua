local trigger_text = ";"

return {
	"saghen/blink.cmp",
	event = "InsertEnter",
	-- optional: provides snippets for the snippet source
	dependencies = {
		"moyiz/blink-emoji.nvim",
		"rafamadriz/friendly-snippets",
		{
			"Saecki/crates.nvim",
			event = { "BufRead Cargo.toml" },
			opts = {},
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

		snippets = {
			preset = "luasnip",
			expand = function(snippet)
				require("luasnip").lsp_expand(snippet)
			end,
			active = function(filter)
				if filter and filter.direction then
					return require("luasnip").jumpable(filter.direction)
				end
				return require("luasnip").in_snippet()
			end,
			jump = function(direction)
				require("luasnip").jump(direction)
			end,
		},

		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},
			ghost_text = { enabled = false },
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer", "emoji" },
			providers = {
				lsp = {
					name = "lsp",
					enabled = true,
					module = "blink.cmp.sources.lsp",
					-- kind = "LSP",
					-- When linking markdown notes, I would get snippets and text in the
					-- suggestions, I want those to show only if there are no LSP
					-- suggestions
					-- Disabling fallbacks as my snippets wouldn't show up
					-- Enabled fallbacks as this seems to be working now
					fallbacks = { "snippets", "buffer" },
					score_offset = 90, -- the higher the number, the higher the priority
				},
				path = {
					name = "Path",
					module = "blink.cmp.sources.path",
					score_offset = 25,
					-- When typing a path, I would get snippets and text in the
					-- suggestions, I want those to show only if there are no path
					-- suggestions
					fallbacks = { "snippets", "buffer" },
					opts = {
						trailing_slash = false,
						label_trailing_slash = true,
						get_cwd = function(context)
							return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
						end,
						show_hidden_files_by_default = true,
					},
				},
				buffer = {
					name = "Buffer",
					enabled = true,
					max_items = 3,
					module = "blink.cmp.sources.buffer",
					min_keyword_length = 4,
					score_offset = 15, -- the higher the number, the higher the priority
				},
				snippets = {
					name = "snippets",
					enabled = true,
					max_items = 8,
					min_keyword_length = 2,
					module = "blink.cmp.sources.snippets",
					score_offset = 85, -- the higher the number, the higher the priority
					-- Only show snippets if I type the trigger_text characters, so
					-- to expand the "bash" snippet, if the trigger_text is ";" I have to
					should_show_items = function()
						local col = vim.api.nvim_win_get_cursor(0)[2]
						local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
						return before_cursor:match(trigger_text .. "%w*$") ~= nil
					end,
					-- After accepting the completion, delete the trigger_text characters
					-- from the final inserted text
					transform_items = function(_, items)
						local col = vim.api.nvim_win_get_cursor(0)[2]
						local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
						local trigger_pos = before_cursor:find(trigger_text .. "[^" .. trigger_text .. "]*$")
						if trigger_pos then
							for _, item in ipairs(items) do
								item.textEdit = {
									newText = item.insertText or item.label,
									range = {
										start = { line = vim.fn.line(".") - 1, character = trigger_pos - 1 },
										["end"] = { line = vim.fn.line(".") - 1, character = col },
									},
								}
							end
						end
						-- NOTE: After the transformation, I have to reload the luasnip source
						-- Otherwise really crazy shit happens and I spent way too much time
						-- figurig this out
						vim.schedule(function()
							require("blink.cmp").reload("snippets")
						end)
						return items
					end,
				},
				-- https://github.com/moyiz/blink-emoji.nvim
				emoji = {
					module = "blink-emoji",
					name = "Emoji",
					score_offset = 15, -- the higher the number, the higher the priority
					opts = { insert = true }, -- Insert emoji (default) or complete its name
				},
			},
		},

		signature = { enabled = true },
	},
}

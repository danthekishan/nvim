return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		name = "which-key",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		config = function()
			local wk = require("which-key")
			local harpoon = require("harpoon")

			-- ======================================
			-- WHICH KEY MAPPINGS
			-- ======================================

			wk.add({
				{ "<leader>s", group = "⚡ [S]earch and Replace" },

				-- explorer
				{
					"<leader>e",
					function()
						MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
					end,
					desc = "Explorer",
				},

				-- harpoon
				{
					"ga",
					function()
						harpoon:list():add()
					end,
					desc = "🎣 Harpoon Mark [A]dd",
				},
				{
					"gH",
					function()
						harpoon.ui:toggle_quick_menu(harpoon:list())
					end,
					desc = "🎣 [H]arpoon List",
				},

				-- find
				{ "<leader>f", group = "🔍 [F]ind" },
				{
					"<leader>fj",
					function()
						require("flash").jump()
					end,
					desc = "⚡ Flash [J]ump",
				},
				{
					"<leader>ft",
					function()
						require("flash").treesitter()
					end,
					desc = "🌳 Flash [T]reesitter",
				},
				{
					"<leader>fT",
					function()
						require("flash").treesitter_search()
					end,
					desc = "🔍 Flash [T]reesitter Search",
				},

				-- lsp
				{ "<leader>l", group = "🧠 [L]SP" },
				{
					"<leader>li",
					function()
						vim.lsp.buf.code_action({
							apply = true,
							context = {
								only = { "source.organizeImports" },
								diagnostics = {},
							},
						})
					end,
					desc = "📦 Organize [I]mports",
				},

				-- buffer
				{ "<leader>b", group = "📑 [B]uffers" },
				{
					"<leader>bc",
					function()
						local bd = require("mini.bufremove").delete
						if vim.bo.modified then
							local choice =
								vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
							if choice == 1 then -- Yes
								vim.cmd.write()
								bd(0)
							elseif choice == 2 then -- No
								bd(0, true)
							end
						else
							bd(0)
						end
					end,
					desc = "🗑️ Delete Buffer",
				},
				{ "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
				{ "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
				{ "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
				{ "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
				{ "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
				{ "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
				{ "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
				{ "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
				{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
				{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },

				-- extra
				{ "<leader>x", group = "🎉 [X]tra" },
				{ "<leader>xl", ":Lazy<CR>", desc = "🛋️ [L]azy" },
				{ "<leader>xm", ":Mason<CR>", desc = "🧱 [M]ason" },

				-- git
				{ "<leader>g", group = "🎉 [G]it" },
				{
					"<leader>gd",
					function()
						MiniDiff.toggle_overlay()
					end,
					desc = "📝 [D]iff",
				},
			})
		end,
	},
}

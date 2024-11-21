return {
	{
		"nvim-telescope/telescope.nvim",
		lazy = false,
		priority = 1000,
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = function(_, opts)
			local function flash(prompt_bufnr)
				require("flash").jump({
					pattern = "^",
					label = { after = { 0, 0 } },
					search = {
						mode = "search",
						exclude = {
							function(win)
								return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
							end,
						},
					},
					action = function(match)
						local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
						picker:set_selection(match.pos[1] - 1)
					end,
				})
			end
			opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
				mappings = {
					n = { s = flash },
					i = { ["<c-s>"] = flash },
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		lazy = "VeryLazy",
		config = function()
			-- This is your opts table
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = {
						"venv",
						"__pycache__",
						"%.xlsx",
						"%.jpg",
						"%.png",
						"%.webp",
						"%.pdf",
						"%.odt",
						"%.ico",
						"cdk%.out",
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select")
			require("telescope").load_extension("luasnip")
		end,
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").load_extension("file_browser")
		end,
	},
}

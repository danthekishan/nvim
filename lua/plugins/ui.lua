return {
	--
	-- -- noice
	-- {
	--   "folke/noice.nvim",
	--   event = "VeryLazy",
	--   opts = {
	--     -- add any options here
	--   },
	--   dependencies = {
	--     -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
	--     "MunifTanjim/nui.nvim",
	--     -- OPTIONAL:
	--     --   `nvim-notify` is only needed, if you want to use the notification view.
	--     --   If not available, we use `mini` as the fallback
	--     "rcarriga/nvim-notify",
	--   },
	--   config = function()
	--     require("noice").setup({
	--       lsp = {
	--         signature = {
	--           enabled = false,
	--         },
	--         hover = {
	--           enabled = true,
	--           silent = true, -- set to true to not show a message if hover is not available
	--           view = nil,    -- when nil, use defaults from documentation
	--           ---@type NoiceViewOptions
	--           opts = {},     -- merged with defaults from documentation
	--         },
	--       },
	--       -- you can enable a preset for easier configuration
	--       presets = {
	--         lsp_doc_border = true, -- add a border to hover docs and signature help
	--       },
	--     })
	--   end,
	--
	-- },
	--
	-- -- notify
	-- {
	--   "rcarriga/nvim-notify",
	--   config = function()
	--     require("notify").setup({
	--       background_colour = "#000000",
	--     })
	--   end,
	-- },

	-- {
	--   "rose-pine/neovim",
	--   name = "rose-pine",
	--   lazy = false,
	--   config = function()
	--     require("rose-pine").setup({
	--       variant = "main",
	--       dim_inactive_windows = true,
	--       styles = {
	--         transparency = false,
	--       },
	--       -- highlight_groups = {
	--       --   CurSearch = { fg = "base", bg = "leaf", inherit = false },
	--       --   Search = { fg = "text", bg = "leaf", blend = 20, inherit = false },
	--       --   TelescopeBorder = { fg = "overlay", bg = "overlay" },
	--       --   TelescopeNormal = { fg = "subtle", bg = "overlay" },
	--       --   TelescopeSelection = { fg = "text", bg = "highlight_med" },
	--       --   TelescopeSelectionCaret = { fg = "love", bg = "highlight_med" },
	--       --   TelescopeMultiSelection = { fg = "text", bg = "highlight_high" },
	--       --
	--       --   TelescopeTitle = { fg = "base", bg = "love" },
	--       --   TelescopePromptTitle = { fg = "base", bg = "pine" },
	--       --   TelescopePreviewTitle = { fg = "base", bg = "iris" },
	--       --
	--       --   TelescopePromptNormal = { fg = "text", bg = "surface" },
	--       --   TelescopePromptBorder = { fg = "surface", bg = "surface" },
	--       -- },
	--     })
	--   end,
	-- },
	--

	-- -- dressing
	-- {
	-- 	"stevearc/dressing.nvim",
	-- 	lazy = false,
	-- 	init = function()
	-- 		---@diagnostic disable-next-line: duplicate-set-field
	-- 		vim.ui.select = function(...)
	-- 			require("lazy").load({ plugins = { "dressing.nvim" } })
	-- 			return vim.ui.select(...)
	-- 		end
	-- 		---@diagnostic disable-next-line: duplicate-set-field
	-- 		vim.ui.input = function(...)
	-- 			require("lazy").load({ plugins = { "dressing.nvim" } })
	-- 			return vim.ui.input(...)
	-- 		end
	-- 	end,
	-- },

	{
		"nvim-lua/plenary.nvim",
		lazy = false,
	},

	{
		"nvchad/ui",
		lazy = false,
		config = function()
			require("nvchad")
			local nvb = require("nvchad.tabufline")
			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "H", function()
				nvb.prev()
			end, opts)
			vim.keymap.set("n", "L", function()
				nvb.next()
			end, opts)
		end,
	},

	{
		"nvchad/base46",
		event = "InsertEnter", -- Lazy load on entering insert mode
		build = function()
			require("base46").load_all_highlights()
		end,
	},
}

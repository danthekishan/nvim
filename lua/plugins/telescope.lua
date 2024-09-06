return {
  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    lazy = "VeryLazy",
    config = function()
      -- This is your opts table
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = {
            "venv", "__pycache__", "%.xlsx", "%.jpg", "%.png", "%.webp",
            "%.pdf", "%.odt", "%.ico", "cdk%.out"
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
      require('telescope').load_extension('luasnip')
    end,
  },
}

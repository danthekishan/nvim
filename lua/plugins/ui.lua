return {

  -- noice
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          hover = {
            enabled = true,
            silent = true, -- set to true to not show a message if hover is not available
            view = nil,    -- when nil, use defaults from documentation
            ---@type NoiceViewOptions
            opts = {},     -- merged with defaults from documentation
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },
      })
    end,

  },

  -- notify
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#000000",
      })
    end,
  },

  -- lualine
  {
    "nvim-lualine/lualine.nvim",
    name = "lualine",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local breadcrump_sep = " ⟩ "
      require("lualine").setup({
        sections = {
          lualine_c = {
            {
              "filename",
              path = 1,
              separator = vim.trim(breadcrump_sep),
              fmt = function(str)
                local path_separator = package.config:sub(1, 1)
                return str:gsub(path_separator, breadcrump_sep)
              end,
            },
          },
        },
      })
    end,
  },

  -- colorscheme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    config = function()
      require("rose-pine").setup({
        variant = "main",
        dim_inactive_windows = true,
        styles = {
          transparency = false,
        },
        highlight_groups = {
          CurSearch = { fg = "base", bg = "leaf", inherit = false },
          Search = { fg = "text", bg = "leaf", blend = 20, inherit = false },
          TelescopeBorder = { fg = "overlay", bg = "overlay" },
          TelescopeNormal = { fg = "subtle", bg = "overlay" },
          TelescopeSelection = { fg = "text", bg = "highlight_med" },
          TelescopeSelectionCaret = { fg = "love", bg = "highlight_med" },
          TelescopeMultiSelection = { fg = "text", bg = "highlight_high" },

          TelescopeTitle = { fg = "base", bg = "love" },
          TelescopePromptTitle = { fg = "base", bg = "pine" },
          TelescopePreviewTitle = { fg = "base", bg = "iris" },

          TelescopePromptNormal = { fg = "text", bg = "surface" },
          TelescopePromptBorder = { fg = "surface", bg = "surface" },
        },
      })
    end,
  },

  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      local transparent = false -- set to true if you would like to enable transparency

      local bg = "#011628"
      local bg_dark = "#011423"
      local bg_highlight = "#143652"
      local bg_search = "#0A64AC"
      local bg_visual = "#275378"
      local fg = "#CBE0F0"
      local fg_dark = "#B4D0E9"
      local fg_gutter = "#627E97"
      local border = "#547998"

      require("tokyonight").setup({
        style = "night",
        transparent = transparent,
        styles = {
          sidebars = transparent and "transparent" or "dark",
          floats = transparent and "transparent" or "dark",
        },
        on_colors = function(colors)
          colors.bg = bg
          colors.bg_dark = transparent and colors.none or bg_dark
          colors.bg_float = transparent and colors.none or bg_dark
          colors.bg_highlight = bg_highlight
          colors.bg_popup = bg_dark
          colors.bg_search = bg_search
          colors.bg_sidebar = transparent and colors.none or bg_dark
          colors.bg_statusline = transparent and colors.none or bg_dark
          colors.bg_visual = bg_visual
          colors.border = border
          colors.fg = fg
          colors.fg_dark = fg_dark
          colors.fg_float = fg
          colors.fg_gutter = fg_gutter
          colors.fg_sidebar = fg_dark
        end,
      })
    end,
  },

  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nightfox").setup({
        options = {
          transparent = true,
        },
      })
    end,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
      })
    end,
  },

  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    lazy = false,
    priority = 1000,
    config = function()
      -- Default options:
      require('kanagawa').setup({
        transparent = false, -- do not set background color
        theme = "wave",      -- Load "wave" theme when 'background' option is not set
        background = {       -- map the value of 'background' option to a theme
          dark = "wave",     -- try "dragon" !
          light = "lotus"
        },
        overrides = function(colors)
          local theme = colors.theme
          return {
            -- telescope
            TelescopeTitle = { fg = theme.ui.special, bold = true },
            TelescopePromptNormal = { bg = theme.ui.bg_p1 },
            TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
            TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
            TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
            TelescopePreviewNormal = { bg = theme.ui.bg_dim },
            TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

            -- pmenu
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },

            -- Popular plugins that open floats will link to NormalFloat by default;
            -- set their background accordingly if you wish to keep them dark and borderless
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          }
        end,
      })
    end
  },


  -- neo tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        window = {
          mappings = {
            ["o"] = "open",
          },
        },
      })
    end,
  },

  -- dressing
  {
    "stevearc/dressing.nvim",
    lazy = false,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- buffer line
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "echasnovski/mini.bufremove",
    },
    opts = {
      options = {
        themable = true,
        close_command = function(n)
          require("mini.bufremove").delete(n, false)
        end,
        right_mouse_command = function(n)
          require("mini.bufremove").delete(n, false)
        end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        numbers = function(opts)
          return string.format('%s.%s', opts.lower(opts.id), opts.lower(opts.ordinal))
        end,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
          },
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
    end,
  },
}

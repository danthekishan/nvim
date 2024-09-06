return {
  -- lsp config
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      --    This function gets run when an LSP attaches to a particular buffer.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("dan-lsp-attach", { clear = true }),
        callback = function(event)
          -- lsp related keymaps
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- custom keymaps
          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
          map("gD", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
          map("<leader>br", vim.lsp.buf.rename, "[R]ename")
          map("<leader>la", vim.lsp.buf.code_action, "Code [A]ction")
          map("<leader>lf", vim.lsp.buf.format, "Code [F]ormat")
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- highlight references and remove
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- LSP servers and clients communication
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      -- LSP servers
      local servers = {

        -- pyright
        pyright = {
          -- cmd = {...},
          -- filetyles = {...},
          -- capabilities = {...},
          on_attach = function(client, bufnr)
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end,
          settings = {
            pyright = {
              disableOrganizeImports = true, -- Using Ruff
              typeCheckingMode = "standard",
            },
            python = {
              analysis = {
                exclude = { "cdk.out" },
              },
            }
          },
        },

        -- ruff
        -- ruff_lsp = {
        --   -- cmd = {...},
        --   -- filetyles = {...},
        --   -- capabilities = {...},
        -- },

        -- tsserver
        tsserver = {
          -- cmd = {...},
          -- filetyles = {...},
          -- capabilities = {...},
        },

        tailwindcss = {
          -- cmd = {...},
          -- filetyles = {...},
          -- capabilities = {...},
        },

        rust_analyzer = {
          -- cmd = {...},
          -- filetyles = {...},
          -- capabilities = {...},
          autostart = true,
          on_attach = function(client, bufnr)
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end,
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
              }
            },
          },
        },

        -- gopls
        gopls = {
          -- cmd = {...},
          -- filetyles = {...},
          -- capabilities = {...},
          autostart = true,
          on_attach = function(client, bufnr)
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end,
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
              gofumpt = true,
            },
          },
        },

        -- lua
        lua_ls = {
          -- cmd = {...},
          -- filetyles = {...},
          -- capabilities = {...},
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                library = {
                  "${3rd}/luv/library",
                  unpack(vim.api.nvim_get_runtime_file("", true)),
                },
              },
              -- you can toggle below to ignore Lua_ls noisy warnings
              -- diagnostics = { disable = {"missing-fields"} },
            },
          },
        },
      }

      -- installing mason
      require("mason").setup()

      -- installing mason
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "gopls",
        "eslint_d",
        "lua_ls",
        "pyright",
        "tsserver",
        "rust_analyzer",
        "ruff",
        "stylua",
        "prettier",
        "goimports",
        "gofumpt",
        "tailwindcss-language-server",
        "css-lsp"
      })
      require("mason-tool-installer").setup({
        ensure_installed = ensure_installed,
      })

      -- mason lsp config
      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            require("lspconfig")[server_name].setup({
              cmd = server.cmd,
              settings = server.settings,
              filetypes = server.filetypes,
              capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {}),
              autostart = server.autostart or true,
              on_attach = server.on_attach
            })
          end,
        },
      })
    end,
  },

  -- lint
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost", "BufReadPost", "InsertLeave" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        python = {
          "ruff"
        }
      }
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },

  -- autoformat
  {
    "stevearc/conform.nvim",
    -- format on save or <leader>lf
    -- event = { "BufReadPost", "BufNewFile" },
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = function(bufnr)
          if require("conform").get_formatter_info("ruff_format", bufnr).available then
            return { "ruff_format" }
          else
            return { "isort", "black" }
          end
        end,
        javascript = { "prettier" },
        go = { "goimports", "gofmt" },
        json = { "prettier" }
      },
    },
  },
}

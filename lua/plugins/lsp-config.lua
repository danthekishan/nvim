return {
	{
		"folke/lazydev.nvim",
		event = { "BufReadPost", "BufNewFile" },
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
	-- lsp config
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall" },
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
					map("<leader>la", vim.lsp.buf.code_action, "Code [A]ction")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("K", vim.lsp.buf.hover, "Def")
					map("ge", vim.diagnostic.open_float, "Error")

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
						},
					},
				},

				-- ruff
				-- ruff_lsp = {
				--   -- cmd = {...},
				--   -- filetyles = {...},
				--   -- capabilities = {...},
				-- },

				-- tsonsserver
				ts_ls = {
					-- cmd = {...},
					-- filetyles = {...},
					-- capabilities = {...},
					alt_name = "ts_ls",
				},

				tailwindcss = {
					-- cmd = {...},
					-- filetyles = {...},
					-- capabilities = {...},
				},

				-- rust_analyzer = {
				--   -- cmd = {...},
				--   -- filetyles = {...},
				--   -- capabilities = {...},
				--   autostart = true,
				--   -- on_attach = function(client, bufnr)
				--   --   vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				--   -- end,
				--   -- capabilities = capabilities,
				--   root_dir = function()
				--     return vim.fn.getcwd()
				--   end,
				--   cmd = { "rustup", "run", "stable", "rust-analyzer" },
				--   settings = {
				--     rust_analyzer = {
				--       cargo = {
				--         allFeatures = true,
				--       },
				--       checkOnSave = {
				--         command = "cargo clippy",
				--       },
				--     },
				--   },
				-- },

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
								library = vim.api.nvim_get_runtime_file("lua", true),
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
				"eslint",
				"lua_ls",
				"pyright",
				"ts_ls",
				"rust_analyzer",
				"ruff",
				"stylua",
				"prettier",
				"goimports",
				"gofumpt",
				"tailwindcss-language-server",
				"css-lsp",
			})
			require("mason-tool-installer").setup({
				ensure_installed = ensure_installed,
			})

			-- mason lsp config
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						if server_name == "rust_analyzer" then
							return
						end

						local server = servers[server_name] or {}
						local name = server["alt_name"] or server_name

						require("lspconfig")[name].setup({
							cmd = server.cmd,
							settings = server.settings,
							filetypes = server.filetypes,
							capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {}),
							autostart = server.autostart or true,
							on_attach = server.on_attach,
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
					"ruff",
				},
				js = {
					"eslint",
				},
			}
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},

	-- autoformat
	{
		"stevearc/conform.nvim",
		-- format on save or <leader>lf
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				-- Customize or remove this keymap to your liking
				"<leader>lf",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		opts = {
			notify_on_error = true,
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
				javascript = { "prettier", stop_after_first = true },
				javascriptreact = { "prettier", stop_after_first = true },
				go = { "goimports", "gofmt" },
				json = { "prettier" },
				markdown = { "prettier" },
			},
		},
	},
}

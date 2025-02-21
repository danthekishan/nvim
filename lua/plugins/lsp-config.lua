local lsp_utils = require("utils.lsp-utils")

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
			-- Core LSP and installation management
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"saghen/blink.cmp",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			-- UI improvements
			{ "j-hui/fidget.nvim", opts = {} },
		},

		opts = {
			-- Diagnostic configuration
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅙", -- Replace with your preferred icon
						[vim.diagnostic.severity.WARN] = "󰀦", -- Replace with your preferred icon
						[vim.diagnostic.severity.HINT] = "󰌵", -- Replace with your preferred icon
						[vim.diagnostic.severity.INFO] = "󰋼", -- Replace with your preferred icon
					},
				},
			},
			-- LSP feature toggles
			inlay_hints = {
				enabled = true,
				exclude = { "vue" },
			},
			codelens = {
				enabled = false,
			},
			document_highlight = {
				enabled = true,
			},
			-- Server configurations
			servers = {
				-- Python configuration
				pyright = {
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

				-- TypeScript configuration
				-- ts_ls = {
				-- 	alt_name = "ts_ls",
				-- },

				-- in favour of ts_ls
				vtsls = {
					filetypes = {
						"javascript",
						"javascriptreact",
						"javascript.jsx",
						"typescript",
						"typescriptreact",
						"typescript.tsx",
					},
					settings = {
						complete_function_calls = true,
						vtsls = {
							enableMoveToFileCodeAction = true,
							autoUseWorkspaceTsdk = true,
							experimental = {
								completion = {
									enableServerSideFuzzyMatch = true,
								},
							},
						},
						typescript = {
							updateImportsOnFileMove = { enabled = "always" },
							suggest = {
								completeFunctionCalls = true,
							},
							inlayHints = {
								enumMemberValues = { enabled = true },
								functionLikeReturnTypes = { enabled = true },
								parameterNames = { enabled = "literals" },
								parameterTypes = { enabled = true },
								propertyDeclarationTypes = { enabled = true },
								variableTypes = { enabled = false },
							},
						},
					},
				},

				eslint_lsp = {},

				-- Go configuration
				gopls = {
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

				-- HTML configuration
				html = {
					filetypes = { "html", "javascriptreact", "typescript.tsx", "typescriptreact" },
					settings = {
						html = {
							format = {
								templating = true,
								wrapLineLength = 120,
								wrapAttributes = "auto",
							},
							hover = {
								documentation = true,
								references = true,
							},
						},
					},
				},

				-- CSS configuration remains the same...
				cssls = {
					settings = {
						css = {
							validate = true,
							lint = {
								unknownAtRules = "ignore",
							},
						},
					},
				},

				rust_analyzer = {},

				-- Lua configuration
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								library = vim.api.nvim_get_runtime_file("lua", true),
							},
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
						},
					},
				},

				-- elixir
				elixirls = {},
			},
		},

		config = function(_, opts)
			-- Setup Mason package manager
			require("mason").setup()

			-- Define tools to install
			local ensure_installed = {
				"gopls",
				"eslint",
				"lua_ls",
				"pyright",
				-- "ts_ls",
				"vtsls",
				"html-lsp",
				"rust_analyzer",
				"ruff",
				"stylua",
				"prettier",
				"goimports",
				"gofumpt",
				"css-lsp",
				"elixir-ls",
			}

			-- Install required tools
			require("mason-tool-installer").setup({
				ensure_installed = ensure_installed,
			})

			-- LSP attach configuration
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gp", function()
						lsp_utils.replace_references({ confirm = false })
					end, "replace")

					map("gP", function()
						lsp_utils.replace_references({ confirm = true })
					end, "replace (confirm)")

					map("gw", function()
						lsp_utils.interactive_replace()
					end, "replace (interactive)")

					map("gW", function()
						lsp_utils.replace_references({ preview_only = true })
					end, "replace (preview)")

					map("<leader>la", vim.lsp.buf.code_action, "Code [A]ction")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("ge", vim.diagnostic.open_float, "Show Diagnostic")

					-- Setup document highlighting
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

			-- Setup LSP servers
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Configure diagnostic settings
			vim.diagnostic.config(opts.diagnostics)

			-- Setup mason-lspconfig
			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_installation = false,
				handlers = {
					function(server_name)
						if server_name == "rust_analyzer" then
							return
						end

						local server = opts.servers[server_name] or {}
						local name = server["alt_name"] or server_name

						local server_opts = {
							cmd = server.cmd,
							settings = server.settings,
							filetypes = server.filetypes,
							capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {}),
							autostart = server.autostart or true,
							on_attach = server.on_attach,
						}

						if server_name == "ts_ls" then
							server_opts.root_dir = require("lspconfig.util").root_pattern(".git")
						end

						require("lspconfig")[name].setup(server_opts)
					end,
				},
			})
		end,
	},

	-- lint
	{
		"mfussenegger/nvim-lint",
		event = { "BufWritePost", "BufReadPost", "InsertLeave" },
		opts = {
			-- Event to trigger linters
			events = { "BufWritePost", "BufReadPost", "InsertLeave" },
			linters_by_ft = {
				fish = { "fish" },
				python = { "ruff" },
				elixir = { "credo" },
				-- javascript = { "eslint" },
			},
			linters = {},
		},
		config = function(_, opts)
			local M = {}
			local lint = require("lint")

			-- Configure linters
			for name, linter in pairs(opts.linters) do
				if type(linter) == "table" and type(lint.linters[name]) == "table" then
					lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
					if type(linter.prepend_args) == "table" then
						lint.linters[name].args = lint.linters[name].args or {}
						vim.list_extend(lint.linters[name].args, linter.prepend_args)
					end
				else
					lint.linters[name] = linter
				end
			end
			-- Set up linters by filetype
			lint.linters_by_ft = opts.linters_by_ft

			-- Debounce function to prevent excessive linting
			function M.debounce(ms, fn)
				local timer = vim.uv.new_timer()
				return function(...)
					local argv = { ... }
					timer:start(ms, 0, function()
						timer:stop()
						vim.schedule_wrap(fn)(unpack(argv))
					end)
				end
			end

			-- Main lint function
			function M.lint()
				local names = lint._resolve_linter_by_ft(vim.bo.filetype)
				names = vim.list_extend({}, names)

				-- Add fallback linters
				if #names == 0 then
					vim.list_extend(names, lint.linters_by_ft["_"] or {})
				end

				-- Add global linters
				vim.list_extend(names, lint.linters_by_ft["*"] or {})

				-- Filter out invalid linters
				local ctx = { filename = vim.api.nvim_buf_get_name(0) }
				ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
				names = vim.tbl_filter(function(name)
					local linter = lint.linters[name]
					if not linter then
						vim.notify("Linter not found: " .. name, vim.log.levels.WARN)
					end
					return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
				end, names)

				-- Run linters
				if #names > 0 then
					lint.try_lint(names)
				end
			end

			-- Set up autocommands
			vim.api.nvim_create_autocmd(opts.events, {
				group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
				callback = M.debounce(100, M.lint),
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
			format_on_save = false,
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
				typescript = { "prettier", stop_after_first = true },
				typescriptreact = { "prettier", stop_after_first = true },
				go = { "goimports", "gofmt" },
				json = { "prettier" },
				markdown = { "prettier" },
				rust = { "rustfmt" },
				elixir = { "mix" },
				eelixir = { "mix" },
				heex = { "mix" },
				surface = { "mix" },
			},
		},
	},
}

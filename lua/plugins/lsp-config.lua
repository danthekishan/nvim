local lsp_utils = require("utils.lsp-utils")

return {
	{
		"folke/lazydev.nvim",
		event = { "BufReadPost", "BufNewFile" },
		ft = "lua",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},

	{ "Bilal2453/luvit-meta", lazy = true },

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },

		dependencies = {
			"williamboman/mason.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"saghen/blink.cmp",
			{ "j-hui/fidget.nvim", opts = {} },
		},

		opts = {
			diagnostics = {
				underline = true,
				update_in_insert = false,
				severity_sort = true,

				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},

				float = {
					border = "rounded",
					source = true,
					winblend = 15,
				},

				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅙",
						[vim.diagnostic.severity.WARN] = "󰀦",
						[vim.diagnostic.severity.HINT] = "󰌵",
						[vim.diagnostic.severity.INFO] = "󰋼",
					},
				},
			},

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

			servers = {
				harper_ls = {
					autostart = false,
				},

				clangd = {},
				-- bashls = {},
				pyright = {},
				ols = {},
				ts_ls = {},
				-- eslintd= {},
				zls = {},
				expert = {},

				gopls = {
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

				pyright = {
					settings = {
						pyright = {
							disableOrganizeImports = true,
							typeCheckingMode = "standard",
							diagnosticMode = "workspace",
						},

						python = {
							analysis = {
								exclude = { "cdk.out" },
							},
						},
					},
				},

				html = {
					filetypes = {
						"html",
						"javascriptreact",
						"typescriptreact",
					},
				},

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

				-- lua_ls = {
				-- 	settings = {
				-- 		Lua = {
				-- 			runtime = {
				-- 				version = "LuaJIT",
				-- 			},
				--
				-- 			workspace = {
				-- 				checkThirdParty = false,
				-- 				library = vim.api.nvim_get_runtime_file("lua", true),
				-- 			},
				--
				-- 			hint = {
				-- 				enable = true,
				-- 				setType = false,
				-- 				paramType = true,
				-- 				paramName = "Disable",
				-- 				semicolon = "Disable",
				-- 				arrayIndex = "Disable",
				-- 			},
				-- 		},
				-- 	},
				-- },

				-- emmet_ls = {
				-- 	filetypes = {
				-- 		"html",
				-- 		"css",
				-- 		"scss",
				-- 		"javascript",
				-- 		"javascriptreact",
				-- 		"typescript",
				-- 		"typescriptreact",
				-- 		"vue",
				-- 		"svelte",
				-- 	},
				-- },
			},
		},

		config = function(_, opts)
			require("mason").setup()

			require("mason-tool-installer").setup({
				ensure_installed = {
					"harper-ls",
					"gopls",
					-- "bashls",
					"shfmt",
					"shellcheck",
					-- "eslintd",
					-- "lua_ls",
					"pyright",
					"vtsls",
					"html-lsp",
					"ruff",
					"stylua",
					"prettier",
					"goimports",
					"gofumpt",
					"css-lsp",
					-- "svelte",
					"clangd",
					"clang-format",
					-- "emmet_ls",
					"zls",
					"ols",
					"expert",
				},
			})

			vim.diagnostic.config(opts.diagnostics)

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			for name, server in pairs(opts.servers) do
				vim.lsp.config(
					name,
					vim.tbl_deep_extend("force", server, {
						capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {}),
					})
				)

				if server.autostart ~= false then
					vim.lsp.enable(name)
				end
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),

				callback = function(event)
					local client = vim.lsp.get_client_by_id(event.data.client_id)

					local bufnr = event.buf

					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, {
							buffer = bufnr,
							desc = "LSP: " .. desc,
						})
					end

					map("gp", function()
						lsp_utils.replace_references({
							confirm = false,
						})
					end, "Replace refs")

					map("ge", vim.diagnostic.open_float, "Show Diagnostic")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					map("gw", lsp_utils.interactive_replace, "Replace interactive")

					map("<leader>la", vim.lsp.buf.code_action, "Code Action")

					map("K", function()
						vim.lsp.buf.hover({
							border = "rounded",
						})
					end, "Hover")

					if opts.inlay_hints.enabled and client and client:supports_method("textDocument/inlayHint") then
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end
				end,
			})
		end,
	},

	-- lint
	{
		"mfussenegger/nvim-lint",
		event = { "BufWritePost", "BufReadPost", "InsertLeave" },
		opts = {
			events = { "BufWritePost", "BufReadPost", "InsertLeave" },
			linters_by_ft = {
				fish = { "fish" },
				python = { "ruff" },
				elixir = { "credo" },
			},
			linters = {},
		},
		config = function(_, opts)
			local M = {}
			local lint = require("lint")

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

			lint.linters_by_ft = opts.linters_by_ft

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

			function M.lint()
				local names = lint._resolve_linter_by_ft(vim.bo.filetype)
				names = vim.list_extend({}, names)

				if #names == 0 then
					vim.list_extend(names, lint.linters_by_ft["_"] or {})
				end

				vim.list_extend(names, lint.linters_by_ft["*"] or {})

				local ctx = { filename = vim.api.nvim_buf_get_name(0) }
				ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
				names = vim.tbl_filter(function(name)
					local linter = lint.linters[name]
					if not linter then
						vim.notify("Linter not found: " .. name, vim.log.levels.WARN)
					end
					return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
				end, names)

				if #names > 0 then
					lint.try_lint(names)
				end
			end

			vim.api.nvim_create_autocmd(opts.events, {
				group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
				callback = M.debounce(100, M.lint),
			})
		end,
	},

	-- autoformat
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
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
				svelte = { "prettier", stop_after_first = true },
				css = { "prettier", stop_after_first = true },
				html = { "prettier", stop_after_first = true },
				javascript = { "prettier", stop_after_first = true },
				javascriptreact = { "prettier", stop_after_first = true },
				typescript = { "prettier", stop_after_first = true },
				typescriptreact = { "prettier", stop_after_first = true },
				go = { "goimports", "gofmt" },
				json = { "prettier" },
				jsonl = { "prettier" },
				markdown = { "prettier" },
				rust = { "rustfmt" },
				elixir = { "mix" },
				eelixir = { "mix" },
				heex = { "mix" },
				surface = { "mix" },
				c = { "clang-format" },
				sh = { "shfmt" },
				zig = { "zigfmt" },
				odin = { "odinfmt" },
			},
		},
	},
}

local lsp_utils = require("utils.lsp-utils")

return {
	{
		"folke/lazydev.nvim",
		event = { "BufReadPost", "BufNewFile" },
		ft = "lua", -- only load on lua files
		opts = {
			library = {
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
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"saghen/blink.cmp",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
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
						[vim.diagnostic.severity.ERROR] = "󰅙",
						[vim.diagnostic.severity.WARN] = "󰀦",
						[vim.diagnostic.severity.HINT] = "󰌵",
						[vim.diagnostic.severity.INFO] = "󰋼",
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
				harper_ls = {
					filetypes = { "markdown", "mdx" },
					autostart = true,
					settings = {
						["harper-ls"] = {
							linters = {
								SpellCheck = true,
								RepeatedWords = true,
								LongSentences = true,
								SentenceCapitalization = true,
							},
						},
					},
				},

				clangd = {},

				bashls = {},

				-- Python
				pyright = {
					settings = {
						pyright = {
							disableOrganizeImports = true, -- Using Ruff
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

				ols = {},

				-- TypeScript
				ts_ls = {
					alt_name = "ts_ls",
				},

				eslint = {},

				zls = {},

				-- Go
				gopls = {
					autostart = true,
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

				-- HTML
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

				-- CSS
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

				-- Lua
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

				expert = {},

				emmet_ls = {
					filetypes = {
						"html",
						"css",
						"scss",
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
						"vue",
						"svelte",
					},
				},
			},
		},

		config = function(_, opts)
			require("mason").setup()

			local ensure_installed = {
				"harper-ls",
				"gopls",
				"bashls",
				"shfmt",
				"shellcheck",
				"eslint",
				"lua_ls",
				"pyright",
				"vtsls",
				"html-lsp",
				"ruff",
				"stylua",
				"prettier",
				"goimports",
				"gofumpt",
				"css-lsp",
				"exprt",
				"svelte",
				"clangd",
				"clang-format",
				"emmet_ls",
				"zls",
				"ols",
				"expert",
			}

			require("mason-tool-installer").setup({
				ensure_installed = ensure_installed,
			})

			-- LSP attach configuration
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					local bufnr = event.buf

					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
					end

					-- Custom rename/replace utilities
					map("gp", function()
						lsp_utils.replace_references({ confirm = false })
					end, "Replace references")

					map("gP", function()
						lsp_utils.replace_references({ confirm = true })
					end, "Replace references (confirm)")

					map("gw", function()
						lsp_utils.interactive_replace()
					end, "Replace (interactive)")

					map("gW", function()
						lsp_utils.replace_references({ preview_only = true })
					end, "Replace (preview)")

					-- LSP actions
					-- Note: grn=rename, grr=references, gri=implementation, gra=code_action, K=hover are nvim 0.11+ defaults
					map("<leader>la", vim.lsp.buf.code_action, "Code [A]ction")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("ge", vim.diagnostic.open_float, "Show Diagnostic")

					-- Inlay hints toggle
					if opts.inlay_hints.enabled then
						map("<leader>lh", function()
							vim.lsp.inlay_hint.enable(
								not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
								{ bufnr = bufnr }
							)
						end, "Toggle Inlay [H]ints")
					end

					-- Enable inlay hints if supported and not excluded
					if
						opts.inlay_hints.enabled
						and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[bufnr].filetype)
						and client
						and client:supports_method("textDocument/inlayHint")
					then
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end

					-- Codelens
					if opts.codelens.enabled and client and client:supports_method("textDocument/codeLens") then
						vim.lsp.codelens.refresh()
						vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
							buffer = bufnr,
							callback = vim.lsp.codelens.refresh,
						})
					end

				-- Harper grammar checker: add word to dictionary
				if client and client.name == "harper_ls" then
					local function harper_add(command_name)
						local word = vim.fn.expand("<cword>")
						if word == "" then
							vim.notify("No word under cursor", vim.log.levels.WARN)
							return
						end
						local uri = vim.uri_from_bufnr(0)
						local clients = vim.lsp.get_clients({ bufnr = 0, name = "harper_ls" })
						if #clients == 0 then
							vim.notify("harper-ls not attached", vim.log.levels.WARN)
							return
						end
						clients[1]:request("workspace/executeCommand", {
							command = command_name,
							arguments = { word, uri },
						}, function(err)
							if err then
								vim.notify("Harper error: " .. err.message, vim.log.levels.ERROR)
							else
								vim.notify("Added '" .. word .. "' to Harper dictionary", vim.log.levels.INFO)
							end
						end)
					end

					map("zg", function()
						harper_add("HarperAddToUserDict")
					end, "Harper: add to user dict")
					map("zG", function()
						harper_add("HarperAddToWSDict")
					end, "Harper: add to workspace dict")
					map("zf", function()
						harper_add("HarperAddToFileDict")
					end, "Harper: add to file dict")
				end

				-- Document highlight
				if
					opts.document_highlight.enabled
					and client
					and client:supports_method("textDocument/documentHighlight")
				then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = bufnr,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = bufnr,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})

			-- Cleanup on LSP detach
			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
				callback = function(event)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ buffer = event.buf, group = "lsp-attach" })
				end,
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			vim.diagnostic.config(opts.diagnostics)

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

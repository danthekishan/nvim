return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- ──────────────────────────────────────────────────────────────
		-- Core modules
		-- ──────────────────────────────────────────────────────────────
		bigfile = { enabled = true },
		quickfile = { enabled = true },

		-- ──────────────────────────────────────────────────────────────
		-- UI modules
		-- ──────────────────────────────────────────────────────────────
		dashboard = { enabled = true },
		indent = { enabled = true },   -- NEW: static indent guides (complements mini.indentscope)
		scroll = { enabled = true },
		statuscolumn = { enabled = true }, -- NEW: pretty status column with signs/folds/numbers

		-- ──────────────────────────────────────────────────────────────
		-- Input / notifications
		-- ──────────────────────────────────────────────────────────────
		input = { enabled = true }, -- NEW: replaces vim.ui.input with a nicer float
		notifier = {
			enabled = true,
			timeout = 3000,
			style = "fancy", -- "compact" | "fancy" | "minimal"
		},

		-- ──────────────────────────────────────────────────────────────
		-- Picker (replaces telescope)
		-- ──────────────────────────────────────────────────────────────
		picker = { enabled = true },

		-- ──────────────────────────────────────────────────────────────
		terminal = {
			enabled = true,
			win = {
				keys = {
					-- q in normal mode hides the terminal (keeps process alive)
					q = "hide",
					-- gf opens the file under cursor from the terminal
					gf = function(self)
						local f = vim.fn.findfile(vim.fn.expand("<cfile>"), "**")
						if f == "" then
							Snacks.notify.warn("No file under cursor")
						else
							self:hide()
							vim.schedule(function()
								vim.cmd("e " .. f)
							end)
						end
					end,
					-- double <esc> = exit terminal insert mode
					-- single <esc> passes through to shell (needed for vim, fzf etc inside terminal)
					term_normal = {
						"<esc>",
						function(self)
							self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
							if self.esc_timer:is_active() then
								self.esc_timer:stop()
								vim.cmd("stopinsert")
							else
								self.esc_timer:start(200, 0, function() end)
								return "<esc>"
							end
						end,
						mode = "t",
						expr = true,
						desc = "Double escape to normal mode",
					},
				},
			},
		},

		-- ──────────────────────────────────────────────────────────────
		-- Words -- highlights and jumps between LSP word references
		-- ──────────────────────────────────────────────────────────────
		words = { enabled = true },

		-- ──────────────────────────────────────────────────────────────
		-- Scope -- NEW: treesitter/indent based scope detection
		-- ──────────────────────────────────────────────────────────────
		scope = { enabled = true },

		-- ──────────────────────────────────────────────────────────────
		-- Styles overrides
		-- ──────────────────────────────────────────────────────────────
		styles = {
			notification = {
				relative = "editor",
				wo = { wrap = true },
			},
		},
	},

	keys = {
		-- ──────────────────────────────────────────────────────────────
		-- Terminal -- FIX: added cwd so project context is correct
		--             added mode = "t" so <c-/> also works inside terminal
		-- ──────────────────────────────────────────────────────────────
		{
			"<c-/>",
			function()
				Snacks.terminal.toggle(nil, { cwd = vim.fn.getcwd() })
			end,
			desc = "Toggle Terminal",
		},
		{
			"<c-/>",
			function()
				Snacks.terminal.toggle(nil, { cwd = vim.fn.getcwd() })
			end,
			mode = "t", -- FIX: allows toggling terminal from inside terminal
			desc = "Toggle Terminal",
		},
		-- Numbered terminals: press 1<c-t>, 2<c-t> etc. for separate instances
		{
			"<c-t>",
			function()
				Snacks.terminal.toggle(nil, { cwd = vim.fn.getcwd() })
			end,
			desc = "Toggle Terminal (alt key)",
		},

		-- ──────────────────────────────────────────────────────────────
		-- Notifications
		-- ──────────────────────────────────────────────────────────────
		{
			"<leader>un",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Dismiss All Notifications",
		},
		{
			"<leader>sn",
			function()
				Snacks.picker.notifications()
			end,
			desc = "Notification History",
		},

		-- ──────────────────────────────────────────────────────────────
		-- Git
		-- ──────────────────────────────────────────────────────────────
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>gb",
			function()
				Snacks.git.blame_line()
			end,
			desc = "Git Blame Line",
		},
		{
			"<leader>gB",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Git Browse",
			mode = { "n", "v" }, -- NEW: works on visual selection too (links to line range)
		},
		{
			"<leader>gf",
			function()
				Snacks.lazygit.log_file()
			end,
			desc = "Lazygit Current File History",
		},
		{
			"<leader>gl",
			function()
				Snacks.picker.git_log_line()
			end,
			desc = "Git Log Line",
		},
		{
			"<leader>gc",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Git Log",
		},
		{
			"<leader>gs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Git Status",
		},

		-- ──────────────────────────────────────────────────────────────
		-- Zen / focus
		-- ──────────────────────────────────────────────────────────────
		{
			"<leader>z",
			function()
				Snacks.zen()
			end,
			desc = "Toggle Zen Mode",
		},
		{
			"<leader>Z",
			function()
				Snacks.zen.zoom()
			end,
			desc = "Toggle Zoom",
		},

		-- ──────────────────────────────────────────────────────────────
		-- Scratch buffer
		-- ──────────────────────────────────────────────────────────────
		{
			"<leader>.",
			function()
				Snacks.scratch()
			end,
			desc = "Toggle Scratch Buffer",
		},
		{
			"<leader>S",
			function()
				Snacks.scratch.select()
			end,
			desc = "Select Scratch Buffer", -- NEW: pick from multiple scratch buffers
		},

		-- ──────────────────────────────────────────────────────────────
		-- Picker: core
		-- ──────────────────────────────────────────────────────────────
		{
			"<leader><space>",
			function()
				Snacks.picker.smart()
			end,
			desc = "Smart Find Files", -- NEW: smarter than plain files()
		},
		{
			"<leader>:",
			function()
				Snacks.picker.command_history()
			end,
			desc = "Command History",
		},
		{
			"<leader>;",
			function()
				Snacks.picker.icons()
			end,
			desc = "Icons",
		},
		{
			"<leader>e",
			function()
				Snacks.picker.explorer()
			end,
			desc = "Explorer",
		},

		-- ──────────────────────────────────────────────────────────────
		-- Picker: find
		-- ──────────────────────────────────────────────────────────────
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>fc",
			function()
				Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "Find Config File",
		},
		{
			"<leader>ff",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>fg",
			function()
				Snacks.picker.git_files()
			end,
			desc = "Find Git Files",
		},
		{
			"<leader>fr",
			function()
				Snacks.picker.recent()
			end,
			desc = "Recent Files",
		},
		{
			"<leader>fp",
			function()
				Snacks.picker.projects()
			end,
			desc = "Projects", -- NEW: jump between recent git projects
		},

		-- ──────────────────────────────────────────────────────────────
		-- Picker: grep / search
		-- ──────────────────────────────────────────────────────────────
		{
			"<leader>sb",
			function()
				Snacks.picker.lines()
			end,
			desc = "Buffer Lines",
		},
		{
			"<leader>sB",
			function()
				Snacks.picker.grep_buffers()
			end,
			desc = "Grep Open Buffers",
		},
		{
			"<leader>sg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>sw",
			function()
				Snacks.picker.grep_word()
			end,
			desc = "Grep Word / Selection",
			mode = { "n", "x" },
		},
		{
			'<leader>s"',
			function()
				Snacks.picker.registers()
			end,
			desc = "Registers",
		},
		{
			"<leader>sa",
			function()
				Snacks.picker.autocmds()
			end,
			desc = "Autocmds",
		},
		{
			"<leader>sd",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Diagnostics",
		},
		{
			"<leader>sh",
			function()
				Snacks.picker.help()
			end,
			desc = "Help Pages",
		},
		{
			"<leader>sH",
			function()
				Snacks.picker.highlights()
			end,
			desc = "Highlights",
		},
		{
			"<leader>sj",
			function()
				Snacks.picker.jumps()
			end,
			desc = "Jumps",
		},
		{
			"<leader>sk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Keymaps",
		},
		{
			"<leader>sl",
			function()
				Snacks.picker.loclist()
			end,
			desc = "Location List",
		},
		{
			"<leader>sM",
			function()
				Snacks.picker.man()
			end,
			desc = "Man Pages",
		},
		{
			"<leader>sm",
			function()
				Snacks.picker.marks()
			end,
			desc = "Marks",
		},
		{
			"<leader>sR",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume Last Picker",
		},
		{
			"<leader>sq",
			function()
				Snacks.picker.qflist()
			end,
			desc = "Quickfix List",
		},
		{
			"<leader>ss",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "LSP Symbols",
		},
		{
			"<leader>sS",
			function()
				Snacks.picker.lsp_workspace_symbols()
			end,
			desc = "LSP Workspace Symbols", -- NEW
		},
		{
			"<leader>uC",
			function()
				Snacks.picker.colorschemes()
			end,
			desc = "Colorschemes",
		},

		-- ──────────────────────────────────────────────────────────────
		-- LSP navigation via picker
		-- ──────────────────────────────────────────────────────────────
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions()
			end,
			desc = "Go to Definition",
		},
		{
			"gD",
			function()
				Snacks.picker.lsp_declarations()
			end,
			desc = "Go to Declaration", -- NEW
		},
		{
			"gr",
			function()
				Snacks.picker.lsp_references()
			end,
			nowait = true,
			desc = "References",
		},
		{
			"gI",
			function()
				Snacks.picker.lsp_implementations()
			end,
			desc = "Go to Implementation",
		},
		{
			"gy",
			function()
				Snacks.picker.lsp_type_definitions()
			end,
			desc = "Go to Type Definition",
		},
		{
			"<leader>le",
			function()
				Snacks.picker.diagnostics_buffer()
			end,
			desc = "Diagnostics (buffer)",
		},
		{
			"<leader>lE",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Diagnostics (workspace)",
		},

		-- ──────────────────────────────────────────────────────────────
		-- Words (LSP reference jumping)
		-- ──────────────────────────────────────────────────────────────
		{
			"]]",
			function()
				Snacks.words.jump(vim.v.count1)
			end,
			desc = "Next Reference",
			mode = { "n", "t" },
		},
		{
			"[[",
			function()
				Snacks.words.jump(-vim.v.count1)
			end,
			desc = "Prev Reference",
			mode = { "n", "t" },
		},
	},

	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- ──────────────────────────────────────────────────────
				-- Debug globals (accessible anywhere as dd(...) or bt())
				-- ──────────────────────────────────────────────────────
				_G.dd = function(...)
					Snacks.debug.inspect(...)
				end
				_G.bt = function()
					Snacks.debug.backtrace()
				end
				vim.print = _G.dd -- := command uses snacks pretty printer

				-- ──────────────────────────────────────────────────────
				-- Toggle mappings (all under <leader>u)
				-- ──────────────────────────────────────────────────────
				Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
				Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
				Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle.line_number():map("<leader>ul")
				Snacks.toggle
					.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
					:map("<leader>uc")
				Snacks.toggle.treesitter():map("<leader>uT")
				Snacks.toggle
					.option("background", { off = "light", on = "dark", name = "Dark Background" })
					:map("<leader>ub")
				Snacks.toggle.inlay_hints():map("<leader>uh")
				Snacks.toggle.indent():map("<leader>ug")  -- toggles snacks.indent guides
				Snacks.toggle.dim():map("<leader>uD")
				Snacks.toggle.scroll():map("<leader>uS")  -- NEW: toggle smooth scroll
				Snacks.toggle.zen():map("<leader>uz")      -- NEW: toggle zen via toggle API
			end,
		})

		-- ──────────────────────────────────────────────────────────────
		-- Keep LSP aware of file renames done inside mini.files
		-- ──────────────────────────────────────────────────────────────
		vim.api.nvim_create_autocmd("User", {
			pattern = "MiniFilesActionRename",
			callback = function(event)
				Snacks.rename.on_rename_file(event.data.from, event.data.to)
			end,
		})
	end,
}

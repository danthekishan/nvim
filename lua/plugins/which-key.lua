return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		name = "which-key",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		config = function()
			local wk = require("which-key")
			local tels = require("telescope.builtin")
			local harpoon = require("harpoon")

			-- ======================================
			-- BASIC HARPOON-TELESCOPE CONFIGURATION
			-- ======================================
			local conf = require("telescope.config").values
			local function toggle_telescope(harpoon_files)
				local file_paths = {}
				for _, item in ipairs(harpoon_files.items) do
					table.insert(file_paths, item.value)
				end

				require("telescope.pickers")
					.new({}, {
						prompt_title = "Harpoon",
						finder = require("telescope.finders").new_table({
							results = file_paths,
						}),
						previewer = conf.file_previewer({}),
						sorter = conf.generic_sorter({}),
					})
					:find()
			end

			-- ======================================
			-- WHICH KEY MAPPINGS
			-- ======================================

			-- --------------------------------------
			-- Code Companion
			-- --------------------------------------
			vim.cmd([[cab cc CodeCompanion]])

			wk.add({
				{ "<leader>a", group = "🤖 AI Code Companion" },
				{
					"<leader>aa",
					"<cmd>CodeCompanionActions<cr>",
					desc = "✨ Execute AI Actions",
				},
				{
					"<leader>aa",
					"<cmd>CodeCompanionActions<cr>",
					desc = "✨ Execute AI Actions",
					mode = "v",
				},
				{
					"<leader>ac",
					"<cmd>CodeCompanionChat Toggle<cr>",
					desc = "💬 Toggle AI Chat",
				},
				{
					"<leader>ac",
					"<cmd>CodeCompanionChat Toggle<cr>",
					desc = "💬 Toggle AI Chat",
					mode = "v",
				},
				{
					"<leader>al",
					"<cmd>CodeCompanionChat Add<cr>",
					desc = "➕ Add Selection to Chat",
					mode = "v",
				},
			})

			-- --------------------------------------
			-- EXPLORER
			-- --------------------------------------
			wk.add({
				{
					"<leader>e",
					function()
						MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
					end,
					desc = "🗺️ [E]xplorer",
				},
			})

			-- --------------------------------------
			-- HARPOON
			-- --------------------------------------
			wk.add({
				{
					"ga",
					function()
						harpoon:list():add()
					end,
					desc = "🎣 Harpoon Mark [A]dd",
				},
				{
					"gh",
					function()
						toggle_telescope(harpoon:list())
					end,
					desc = "🎣 [H]arpoon",
				},
				{
					"gH",
					function()
						harpoon.ui:toggle_quick_menu(harpoon:list())
					end,
					desc = "🎣 [H]arpoon List",
				},
				{ "gq", "<cmd>Noice dismiss<CR>", desc = "🚪 [Q]uit Noice" },
			})

			-- --------------------------------------
			-- BUFFER KEYMAPS
			-- --------------------------------------
			wk.add({
				{ "<leader>b", group = "📑 [B]uffers" },
				{ "<leader>bb", tels.buffers, desc = "🔍 Find [B]uffers" },
				{
					"<leader>bc",
					function()
						local bd = require("mini.bufremove").delete
						if vim.bo.modified then
							local choice =
								vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
							if choice == 1 then -- Yes
								vim.cmd.write()
								bd(0)
							elseif choice == 2 then -- No
								bd(0, true)
							end
						else
							bd(0)
						end
					end,
					desc = "🗑️ Delete Buffer",
				},
			})

			-- --------------------------------------
			-- FIND KEYMAPS
			-- --------------------------------------
			wk.add({
				{ "<leader>f", group = "🔍 [F]ind" },
				{ "<leader>fr", tels.resume, desc = "⏯️ [R]esume Last" },
				{ "<leader>ff", tels.find_files, desc = "📁 [F]ind Files" },
				{ "<leader>fg", tels.git_files, desc = "🌳 Find [G]it Files" },
				{ "<leader>fk", tels.keymaps, desc = "⌨️ Find [K]eymaps" },
				{ "<leader>fh", tels.help_tags, desc = "❓ Find [H]elp Tags" },
				{ "<leader>fl", tels.live_grep, desc = "🔎 [L]ive Grep" },
				{ "<leader>fw", tels.grep_string, desc = "🔤 [W]ord Grep" },
				{
					"<leader>fL",
					function()
						tels.live_grep({
							grep_open_files = true,
							prompt_title = "Live Grep in Open Buffers",
						})
					end,
					desc = "🔎 Live Grep in Open Buffers",
				},
				{ "<leader>fb", tels.buffers, desc = "📑 Find [B]uffers" },
				{ "<leader>fs", tels.lsp_workspace_symbols, desc = "🏷️ Document [S]ymbols" },
				{ "<leader>fS", tels.lsp_dynamic_workspace_symbols, desc = "🏷️ Workspace [S]ymbols" },
				{
					"<leader>fj",
					function()
						require("flash").jump()
					end,
					desc = "⚡ Flash [J]ump",
				},
				{
					"<leader>ft",
					function()
						require("flash").treesitter()
					end,
					desc = "🌳 Flash [T]reesitter",
				},
				{
					"<leader>fT",
					function()
						require("flash").treesitter_search()
					end,
					desc = "🔍 Flash [T]reesitter Search",
				},
				{
					"<leader>fe",
					":Telescope file_browser<CR>",
					desc = "File Browser",
				},
			})

			-- --------------------------------------
			-- LSP KEYMAPS
			-- --------------------------------------
			wk.add({
				{ "<leader>l", group = "🧠 [L]SP" },
				{
					"<leader>ld",
					function()
						require("telescope.builtin").diagnostics({ reuse_win = true })
					end,
					desc = "🩺 [D]iagnostics",
				},
				{ "<leader>lt", "<cmd>Trouble diagnostics toggle<cr>", desc = "🚦 [T]rouble Toggle" },
				{
					"<leader>lT",
					"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
					desc = "📑 Buffer Diagnostics (Trouble)",
				},
				{ "<leader>ls", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "🏷️ Symbols (Trouble)" },
				{
					"<leader>ll",
					"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
					desc = "📚 LSP Definitions (Trouble)",
				},
				{ "<leader>lL", "<cmd>Trouble loclist toggle<cr>", desc = "📍 Location List (Trouble)" },
				{ "<leader>lq", "<cmd>Trouble qflist toggle<cr>", desc = "🚀 Quickfix List (Trouble)" },
				{ "<leader>ly", tels.lsp_document_symbols, desc = "🏷️ Document S[Y]mbols" },
				{ "<leader>lm", tels.lsp_dynamic_workspace_symbols, desc = "🌐 Workspace Sy[M]bols" },
				{
					"<leader>li",
					function()
						vim.lsp.buf.code_action({
							apply = true,
							context = {
								only = { "source.organizeImports" },
								diagnostics = {},
							},
						})
					end,
					desc = "📦 Organize [I]mports",
				},
			})

			-- --------------------------------------
			-- SHORTCUTS
			-- --------------------------------------
			local function toggle_quickfix()
				local qf_exists = false

				for _, win in pairs(vim.fn.getwininfo()) do
					if win.quickfix == 1 then
						qf_exists = true
						break
					end
				end

				if qf_exists then
					vim.cmd("cclose")
				else
					vim.cmd("copen")
				end
			end

			local function highlight_vimgrep()
				local pattern = vim.fn.input("Enter search pattern (regex): ")
				local file_type = vim.fn.input("Enter file type (eg: **/*.lua, src/**): ")
				local cmd_str = string.format("vimgrep /%s/ %s", pattern, file_type)
				vim.cmd(cmd_str)
				vim.cmd("copen")
				vim.cmd("set hlsearch")
			end

			local function search_word_in_selected_path()
				local word = vim.fn.expand("<cword>")
				if word == "" then
					vim.notify("No word under cursor", vim.log.levels.INFO)
					return
				end

				require("telescope").extensions.file_browser.file_browser({
					prompt_title = "Select Directory to Search",
					cwd = vim.fn.getcwd(),
					hidden = false,
					attach_mappings = function(prompt_bufnr, map)
						local actions = require("telescope.actions")
						local action_state = require("telescope.actions.state")

						actions.select_default:replace(function()
							local selection = action_state.get_selected_entry()
							actions.close(prompt_bufnr)

							if not selection then
								print("No directory selected.")
								return
							end

							local dir = selection.path or selection[1]
							print("Selected directory:", dir)

							if not selection.is_dir then
								print("Selected path is not a directory.")
								return
							end

							require("telescope.builtin").grep_string({
								search = word,
								search_dirs = { dir },
								prompt_title = string.format("Grep for '%s' in %s", word, dir),
							})
						end)
						return true
					end,
				})
			end

			wk.add({
				{ "<leader>s", group = "⚡ [S]earch and Replace" },
				{ "<leader>ss", search_word_in_selected_path, desc = "Cword to quckfix" },
				-- search and replace
				{ "<leader>sr", ":%s/\\<<C-r><C-w>\\>//g<Left><Left>", desc = "🔄 [R]eplace All" },
				{ "<leader>sc", ":%s/\\<<C-r><C-w>\\>//gc<Left><Left><Left>", desc = "✅ [C]onfirm Replace All" },
				-- vimgrep
				{ "<leader>sq", toggle_quickfix, desc = "Toggle qfixlist" },
				{ "<leader>sj", "<cmd>cnext<CR>zz", desc = "Forward qfixlist" },
				{ "<leader>sk", "<cmd>cprev<CR>zz", desc = "Backward qfixlist" },
				{ "<leader>sv", highlight_vimgrep, desc = "Vimgrep to qfixlist" },
			})

			-- tabs
			wk.add({
				{ "<leader>t", group = "📑 [T]abs" },
				{ "<leader>te", ":tabedit", desc = "📝 Tab [E]dit" },
				{ "<leader>tc", ":tabclose", desc = "🚫 Tab [C]lose" },
				{ "<leader>tn", ":tabnext<CR>", desc = "➡️ [N]ext Tab" },
				{ "<leader>tp", ":tabprev<CR>", desc = "⬅️ [P]rev Tab" },
			})

			-- --------------------------------------
			-- EXTRA
			-- --------------------------------------
			wk.add({
				{ "<leader>x", group = "🎉 [X]tra" },
				{ "<leader>xt", "<cmd>TodoTelescope<cr>", desc = "📝 [T]odo" },
				{ "<leader>xf", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "🔧 [F]ixme" },
				{ "<leader>xn", ":NoiceLast<CR>", desc = "📢 [N]oice Last Message" },
				{ "<leader>xh", ":NoiceTelescope<CR>", desc = "📜 Noice [H]istory" },
				{ "<leader>xl", ":Lazy<CR>", desc = "🛋️ [L]azy" },
				{ "<leader>xm", ":Mason<CR>", desc = "🧱 [M]ason" },
				{ "<leader>xu", ":Telescope luasnip<CR>", desc = "✂️ l[U]asnip" },
				{ "<leader>xc", ":NvCheatsheet<CR>", desc = "🗂️Nv[C]heatsheet" },
			})

			-- --------------------------------------
			-- GIT
			-- --------------------------------------
			wk.add({
				{ "<leader>g", group = "🎉 [G]it" },
				{
					"<leader>gd",
					function()
						MiniDiff.toggle_overlay()
					end,
					desc = "📝 [D]iff",
				},
			})

			-- { "<leader>sl", "<cmd>PlenaryBustedFile %<CR>", desc = "🔄 Test [L]ua" },
		end,
	},
}

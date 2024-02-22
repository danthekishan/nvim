local wk = require("which-key")
local tels = require("telescope.builtin")
local crates = require("crates")
local chatgpt = require("chatgpt")

-- autocmds
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.norg" },
	command = "set conceallevel=3",
})

-- vim keymaps
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<Tab>", ":tabnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":tabprev<CR>", opts)
vim.keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<cr>", opts)
vim.keymap.set("n", "]b", "<cmd>BufferLineCycleNext<cr>", opts)
vim.keymap.set("v", "<Tab>", ">gv", opts)
vim.keymap.set("v", "<S-Tab>", "<gv", opts)
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)
vim.keymap.set("n", "n", "nzz", opts)
vim.keymap.set("n", "N", "Nzz", opts)
vim.keymap.set("n", "-", ":split<CR>", opts)
vim.keymap.set("n", "|", ":vsplit<CR>", opts)

-- lsp vim keymaps
vim.keymap.set("n", "K", vim.lsp.buf.hover)

-- which key mappings
-- n
local normal_mappings = {

	-- g
	["g"] = {
		a = {
			function()
				require("harpoon.mark").add_file()
			end,
			"Harpoon Mark",
		},
		h = {
			function()
				require("harpoon.ui").toggle_quick_menu()
			end,
			"Harpoon",
		},
		q = { "<cmd>Noice dismiss<CR>", "Dismiss Noice" },
		d = {
			function()
				require("telescope.builtin").lsp_definitions({ reuse_win = true })
			end,
			"Goto Definition",
		},
		r = { "<cmd>Telescope lsp_references<cr>", "References" },
		D = { vim.lsp.buf.declaration, "Goto Declaration" },
		I = {
			function()
				require("telescope.builtin").lsp_implementations({ reuse_win = true })
			end,
			"Goto Implementation",
		},
		y = {
			function()
				require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
			end,
			"Goto T[y]pe Definition",
		},
	},

	-- AI
	["<leader>a"] = {
		-- gen nvim (ollama)
		name = "AI",
		g = { ":Gen<CR>", "Ollama Gen" },
		c = { "<cmd>ChatGPT<CR>", "ChatGPT" },
		e = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction" },
		d = { "<cmd>ChatGPTRun docstring<CR>", "Docstring" },
		a = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests" },
		o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code" },
		s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize" },
		f = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs" },
		x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code" },
		r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit" },
		l = { "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis" },
	},

	-- neorg
	["<leader>n"] = {
		name = "Neorg",
		h = { "<cmd>Neorg mode traverse-heading<CR>", "Heading Mode" },
		n = { "<cmd>Neorg mode norg<CR>", "Norg Mode" },
		i = { "<cmd>Neorg index<CR>", "Index" },
		t = { "<cmd>Neorg toc right<CR>", "Toc" },
		m = { "<cmd>Neorg inject-metadata<CR>", "Add Metadata" },
		s = { "<cmd>Neorg generate-workspace-summary<CR>", "Add Summary" },
	},

	-- buffers
	["<leader>b"] = {
		name = "buffers",
		p = { "<Cmd>BufferLineTogglePin<CR>", "Toggle pin" },
		c = {
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
			"Delete Buffer",
		},
	},

	-- explorer
	["<leader>e"] = { ":Neotree reveal<CR>", "Explorer" },

	-- telescope
	["<leader>f"] = {
		name = "Find",
		f = { tels.find_files, "Find Files" },
		g = { tels.git_files, "Find Git Files" },
		k = { tels.keymaps, "Find Keymaps" },
		h = { tels.help_tags, "Find Help Tags" },
		l = { tels.live_grep, "Live Grep" },
		b = { tels.buffers, "Find Buffers" },
		s = { tels.lsp_workspace_symbols, "Document Symbols" },
		S = { tels.lsp_dynamic_workspace_symbols, "Document Symbols" },
		j = {
			function()
				require("flash").jump()
			end,
			"Flash Jump",
		},
		t = {
			function()
				require("flash").treesitter()
			end,
			"Flash Treesitter",
		},
		T = {
			function()
				require("flash").treesitter_search()
			end,
			"Flash Treesitter Search",
		},
	},

	-- lsp
	["<leader>l"] = {
		name = "LSP",
		d = {
			function()
				require("telescope.builtin").diagnostics({ reuse_win = true })
			end,
			"Diagnostics",
		},
		a = { vim.lsp.buf.code_action, "Code Action" },
		f = { vim.lsp.buf.format, "Code Format" },
		t = {
			function()
				require("trouble").toggle()
			end,
			"Trouble Toggle",
		},
		q = {
			function()
				require("trouble").toggle("quickfix")
			end,
			"Quick Fix",
		},
		R = {
			function()
				require("trouble").toggle("lsp_references")
			end,
			"Trouble LSP Refs",
		},
		w = {
			function()
				require("trouble").toggle("document_diagnostics")
			end,
			"Document Diag",
		},
		W = {
			function()
				require("trouble").toggle("workspace_diagnostics")
			end,
			"Workspace Diag",
		},
		s = { "<cmd>AerialToggle<cr>", "Aerial Symbols" },
		i = {
			function()
				vim.lsp.buf.code_action({
					apply = true,
					context = {
						only = { "source.organizeImports" },
						diagnostics = {},
					},
				})
			end,
			"Organize Imports",
		},
		c = {
			name = "crates",
			t = { crates.toggle, "Crates Toggle" },
			r = { crates.reload, "Crates Reload" },

			v = { crates.show_versions_popup, "Crates Versions" },
			f = { crates.show_features_popup, "Crates Features" },
			d = { crates.show_dependencies_popup, "Crates Deps" },

			u = { crates.update_crate, "Update Crate" },
			a = { crates.update_all_crates, "Update All" },

			H = { crates.open_homepage, "Crate Homepage" },
			D = { crates.open_documentation, "Create Docs" },
			C = { crates.open_crates_io, "Crates IO" },
		},
	},

	-- shortcuts
	["<leader>s"] = {
		name = "shortcuts",
		r = { ":%s/\\<<C-r><C-w>\\>//g<Left><Left>", "Replace All" },
		R = { ":%s/\\<<C-r><C-w>\\>//gc<Left><Left><Left>", "Confirm Replace All" },
	},

	-- tabs
	["<leader>t"] = {
		name = "Tabs",
		e = { ":tabedit", "Tab Edit" },
		c = { ":tabclose", "Tab Close" },
		n = { ":tabnext<CR>", "Next Tab" },
		N = { ":tabprev<CR>", "Prev Tab" },
	},

	-- xtra
	["<leader>x"] = {
		name = "Xtra",
		t = { "<cmd>TodoTelescope<cr>", "Todo" },
		T = { "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", "Todo/Fix/Fixme" },
		n = { ":NoiceLast<CR>", "Noice Last Message" },
		N = { ":NoiceTelescope<CR>", "Noice History" },
		l = { ":Lazy<CR>", "Lazy" },
		m = { ":Mason<CR>", "Mason" },
	},
}

-- v
local visual_mappings = {

	-- AI
	["<leader>a"] = {
		-- gen nvim (ollama)
		name = "AI",
		o = { ":Gen<CR>", "Ollama Gen" },
		e = {
			function()
				chatgpt.edit_with_instructions()
			end,
			"Edit with instructions",
		},
	},
}

-- i
local insert_mappings = {}

-- registering
-- normal mappings register
wk.register(normal_mappings, {
	mode = "n", -- NORMAL mode
	silent = true,
	noremap = true,
})

-- visual mappings register
wk.register(visual_mappings, {
	mode = "v", -- VISUAL mode
	silent = true,
	noremap = true,
})

-- insert mappings register
wk.register(insert_mappings, {
	mode = "i", -- INSERT mode
	silent = true,
	noremap = true,
})

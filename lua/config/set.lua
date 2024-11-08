local opt = vim.opt

opt.laststatus = 3
-- ======================================
-- TAB/IDENTATION
-- ======================================
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.breakindent = true
opt.smartindent = true
opt.wrap = false

-- ======================================
-- SEARCH
-- ======================================
opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- ======================================
-- APPEARANCE
-- ======================================
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.scrolloff = 8
opt.cursorline = true
opt.guicursor = "i:ver25-iCursor"
opt.completeopt = "menuone,noinsert,noselect"
opt.fillchars = { eob = " " }
opt.showmode = false
opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }
opt.signcolumn = "yes"
opt.inccommand = "split"

-- ======================================
-- BEHAVIOUR
-- ======================================
opt.hidden = true
opt.errorbells = false
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
opt.isfname:append("@-@")
opt.updatetime = 250
opt.timeoutlen = 300
opt.backspace = "indent,eol,start"
opt.splitright = true
opt.splitbelow = true
opt.iskeyword:append("-")
opt.modifiable = true
opt.mouse = "a" -- enable mouse support
opt.list = true

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
	opt.clipboard = "unnamedplus"
end)

-- ------------------------------------------------------------------
-- highlight yanked text for 200ms using the "Visual" highlight group
-- ------------------------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", {}),
	desc = "Hightlight selection on yank",
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 500 })
	end,
})
vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#ffffff", bg = "NONE" })

-- ------------------------------------------------------------------
-- [[ Basic Keymaps ]]
-- ------------------------------------------------------------------
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- netrw
vim.keymap.set("n", "g;", "<cmd>Ex<CR>")

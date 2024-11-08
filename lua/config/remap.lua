-- ======================================
-- AUTOCMDS
-- ======================================
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.norg" },
	command = "set conceallevel=3",
})

-- ======================================
-- VIM KEYMAPS
-- ======================================
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<Tab>", ":tabnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":tabprev<CR>", opts)
vim.keymap.set("v", "<Tab>", ">gv", opts)
vim.keymap.set("v", "<S-Tab>", "<gv", opts)
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)
vim.keymap.set("n", "n", "nzz", opts)
vim.keymap.set("n", "N", "Nzz", opts)
vim.keymap.set("n", "-", ":split<CR>", opts)
vim.keymap.set("n", "|", ":vsplit<CR>", opts)
vim.keymap.set("n", "=", "<C-w>=<cr>", opts)

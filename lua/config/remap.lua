local notes = require("utils.prog-notes")

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
-- test.lua

-- Create commands
vim.keymap.set("n", "[nn", notes.new_note, { desc = "New Note" })
vim.keymap.set("n", "[nf", notes.find_notes, { desc = "Find Note" })
vim.keymap.set("n", "[ns", notes.scratch_note, { desc = "Scratch Note" }) -- Open scratch note
vim.keymap.set("n", "[nt", notes.todo, { desc = "Todo Note" }) -- Open TODO list
vim.keymap.set("n", "[nl", notes.toggle_last_note, { desc = "Last Note" }) -- Toggle last note
vim.keymap.set("n", "[nc", notes.git_commit_all, { desc = "Note Commit" }) -- Git commit
vim.keymap.set("n", "[np", notes.git_push, { desc = "Note Push" }) -- Git push
vim.keymap.set("n", "[ng", notes.git_status, { desc = "Note status" }) -- Git status

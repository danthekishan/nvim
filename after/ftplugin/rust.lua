-- Rust-specific keymaps for rustaceanvim
-- Override existing LSP keymaps with enhanced Rust functionality

local bufnr = vim.api.nvim_get_current_buf()

-- Override existing <leader>la with rustaceanvim's enhanced code actions
vim.keymap.set("n", "<leader>la", function()
	vim.cmd.RustLsp("codeAction")
end, { silent = true, buffer = bufnr, desc = "LSP: Code [A]ction (Rust enhanced)" })

-- Override existing K with hover + actions
vim.keymap.set("n", "K", function()
	vim.cmd.RustLsp({ "hover", "actions" })
end, { silent = true, buffer = bufnr, desc = "Hover Documentation (Rust enhanced)" })

-- Additional Rust-specific keymaps (keeping your leader+l pattern)
vim.keymap.set("n", "<leader>lr", function()
	vim.cmd.RustLsp("runnables")
end, { silent = true, buffer = bufnr, desc = "LSP: [R]unnables" })

vim.keymap.set("n", "<leader>ld", function()
	vim.cmd.RustLsp("debuggables")
end, { silent = true, buffer = bufnr, desc = "LSP: [D]ebuggables" })

vim.keymap.set("n", "<leader>lt", function()
	vim.cmd.RustLsp("testables")
end, { silent = true, buffer = bufnr, desc = "LSP: [T]estables" })

vim.keymap.set("n", "<leader>lm", function()
	vim.cmd.RustLsp("expandMacro")
end, { silent = true, buffer = bufnr, desc = "LSP: Expand [M]acro" })

vim.keymap.set("n", "<leader>lc", function()
	vim.cmd.RustLsp("openCargo")
end, { silent = true, buffer = bufnr, desc = "LSP: Open [C]argo.toml" })

vim.keymap.set("n", "<leader>lp", function()
	vim.cmd.RustLsp("parentModule")
end, { silent = true, buffer = bufnr, desc = "LSP: [P]arent module" })

vim.keymap.set("n", "<leader>lj", function()
	vim.cmd.RustLsp("joinLines")
end, { silent = true, buffer = bufnr, desc = "LSP: [J]oin lines" })


return {
	"saecki/crates.nvim",
	tag = "stable",
	event = { "BufRead Cargo.toml" },
	config = function()
		require("crates").setup({
			lsp = {
				enabled = true,
				on_attach = function(client, bufnr)
					-- Keymaps for Cargo.toml files
					local opts = { silent = true, buffer = bufnr }

					-- Update crates
					vim.keymap.set(
						"n",
						"<leader>cu",
						require("crates").update_crate,
						vim.tbl_extend("force", opts, { desc = "Update crate" })
					)
					vim.keymap.set(
						"v",
						"<leader>cu",
						require("crates").update_crates,
						vim.tbl_extend("force", opts, { desc = "Update selected crates" })
					)
					vim.keymap.set(
						"n",
						"<leader>ca",
						require("crates").update_all_crates,
						vim.tbl_extend("force", opts, { desc = "Update all crates" })
					)

					-- Upgrade crates
					vim.keymap.set(
						"n",
						"<leader>cU",
						require("crates").upgrade_crate,
						vim.tbl_extend("force", opts, { desc = "Upgrade crate" })
					)
					vim.keymap.set(
						"v",
						"<leader>cU",
						require("crates").upgrade_crates,
						vim.tbl_extend("force", opts, { desc = "Upgrade selected crates" })
					)
					vim.keymap.set(
						"n",
						"<leader>cA",
						require("crates").upgrade_all_crates,
						vim.tbl_extend("force", opts, { desc = "Upgrade all crates" })
					)

					-- Show popups
					vim.keymap.set(
						"n",
						"<leader>cv",
						require("crates").show_versions_popup,
						vim.tbl_extend("force", opts, { desc = "Show versions popup" })
					)
					vim.keymap.set(
						"n",
						"<leader>cf",
						require("crates").show_features_popup,
						vim.tbl_extend("force", opts, { desc = "Show features popup" })
					)
					vim.keymap.set(
						"n",
						"<leader>cd",
						require("crates").show_dependencies_popup,
						vim.tbl_extend("force", opts, { desc = "Show dependencies popup" })
					)

					-- Open URLs
					vim.keymap.set(
						"n",
						"<leader>ch",
						require("crates").open_homepage,
						vim.tbl_extend("force", opts, { desc = "Open homepage" })
					)
					vim.keymap.set(
						"n",
						"<leader>cr",
						require("crates").open_repository,
						vim.tbl_extend("force", opts, { desc = "Open repository" })
					)
					vim.keymap.set(
						"n",
						"<leader>cD",
						require("crates").open_documentation,
						vim.tbl_extend("force", opts, { desc = "Open documentation" })
					)
					vim.keymap.set(
						"n",
						"<leader>cc",
						require("crates").open_crates_io,
						vim.tbl_extend("force", opts, { desc = "Open crates.io" })
					)
				end,
			},
		})
	end,
}


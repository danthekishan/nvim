-- lazyvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- imports
require("dan.globals")
require("dan.set")

-- lazy plugins
local plugins = "plugins"

local opts = {
	defaults = {
		lazy = true,
	},
	install = {},
	rtp = {
		disabled_plugins = {
			"gzip",
			"matchit",
			"matchparen",
			"netrw",
			"netrwPlugin",
			"tarPlugin",
			"tohtml",
			"tutor",
			"zipPlugin",
		},
	},
	change_detection = {
		notify = false,
	},
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
}

require("lazy").setup(plugins, opts)

-- colorsheme
-- vim.cmd("colorscheme kanagawa")
-- vim.cmd("colorscheme duskfox")
vim.cmd("colorscheme rose-pine")
-- vim.cmd("colorscheme tokyonight")
-- vim.cmd("colorscheme catppuccin")

-- after
require("dan.remap")
require("dan.snippets")

-- lint
vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
    callback = function()
        local lint_status, lint = pcall(require, "lint")
        if lint_status then
            lint.try_lint()
        end
    end,
})

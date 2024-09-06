local wk = require("which-key")
local tels = require("telescope.builtin")
local harpoon = require("harpoon")
local ls = require("luasnip")


-- ======================================
-- AUTOCMDS
-- ======================================
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.norg" },
  command = "set conceallevel=3",
})


-- ======================================
-- BASIC HARPOON-TELESCOPE CONFIGURATION
-- ======================================
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers").new({}, {
    prompt_title = "Harpoon",
    finder = require("telescope.finders").new_table({
      results = file_paths,
    }),
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end


-- ======================================
-- VIM KEYMAPS
-- ======================================
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
vim.keymap.set("n", "=", "<C-w>=<cr>", opts)
vim.keymap.set("n", "K", vim.lsp.buf.hover) -- lsp vim keymaps

-- --------------------------------------
-- LUASNIPPET
-- --------------------------------------

-- jump forward within snippet
vim.keymap.set({ "i" }, "<C-k>", function() ls.expand() end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-l>", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-h>", function() ls.jump(-1) end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-E>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })

-- source snippets
vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/lua/dan/snippets.lua<CR>")


-- ======================================
-- WHICH KEY MAPPINGS
-- ======================================

-- --------------------------------------
-- HARPOON
-- --------------------------------------
wk.add({
  { "ga", function() harpoon:list():add() end,             desc = "Harpoon Mark [A]dd" },
  { "gh", function() toggle_telescope(harpoon:list()) end, desc = "[H]arpoon" },
  { "gq", "<cmd>Noice dismiss<CR>",                        desc = "[Q]uit Noice" },
})

-- --------------------------------------
-- AI KEYMAPS (ChatGPT)
-- --------------------------------------
wk.add({
  { "<leader>a",  group = "[A]i" },
  { "<leader>ag", ":Gen<CR>",                                      desc = "Ollama [G]en" },
  { "<leader>ac", "<cmd>ChatGPT<CR>",                              desc = "[C]hatGPT" },
  { "<leader>ae", "<cmd>ChatGPTEditWithInstruction<CR>",           desc = "[E]dit with instruction" },
  { "<leader>ad", "<cmd>ChatGPTRun docstring<CR>",                 desc = "Add [D]ocstring" },
  { "<leader>at", "<cmd>ChatGPTRun add_tests<CR>",                 desc = "Add [T]ests" },
  { "<leader>ao", "<cmd>ChatGPTRun optimize_code<CR>",             desc = "[O]ptimize Code" },
  { "<leader>af", "<cmd>ChatGPTRun fix_bugs<CR>",                  desc = "[F]ix Bugs" },
  { "<leader>ax", "<cmd>ChatGPTRun explain_code<CR>",              desc = "E[X]plain Code" },
  { "<leader>ar", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code [R]eadability Analysis" },
})

-- --------------------------------------
-- BUFFER KEYMAPS
-- --------------------------------------
wk.add({
  { "<leader>b",  group = "[B]uffers" },
  { "<leader>bb", tels.buffers,                   desc = "Find [B]uffers" },
  { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle [P]in" },
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
    desc = "Delete Buffer",
  },
})

-- --------------------------------------
-- EXPLORER
-- --------------------------------------
wk.add({
  { "<leader>e", group = "[E]xplorer" },
  { "<leader>e", ":Neotree reveal<CR>", desc = "[E]xplorer" },
})

-- --------------------------------------
-- FIND KEYMAPS
-- --------------------------------------
wk.add({
  { "<leader>f",  group = "[F]ind" },
  { "<leader>fr", tels.resume,      desc = "[R]esume Last" },
  { "<leader>ff", tels.find_files,  desc = "[F]ind Files" },
  { "<leader>fg", tels.git_files,   desc = "Find [G]it Files" },
  { "<leader>fk", tels.keymaps,     desc = "Find [K]eymaps" },
  { "<leader>fh", tels.help_tags,   desc = "Find [H]elp Tags" },
  { "<leader>fl", tels.live_grep,   desc = "[L]ive Grep" },
  { "<leader>fw", tels.grep_string, desc = "[W]ord Grep" },
  {
    "<leader>fL",
    function()
      tels.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Buffers",
      })
    end,
    desc = "Live Grep in Open Buffers",
  },
  { "<leader>fb", tels.buffers,                       desc = "Find [B]uffers" },
  { "<leader>fs", tels.lsp_workspace_symbols,         desc = "Document [S]ymbols" },
  { "<leader>fS", tels.lsp_dynamic_workspace_symbols, desc = "Document [S]ymbols" },
  {
    "<leader>fj",
    function()
      require("flash").jump()
    end,
    desc = "Flash [J]ump",
  },
  {
    "<leader>ft",
    function()
      require("flash").treesitter()
    end,
    desc = "Flash [T]reesitter",
  },
  {
    "<leader>fT",
    function()
      require("flash").treesitter_search()
    end,
    desc = "Flash [T]reesitter Search",
  },
})

-- --------------------------------------
-- LSP KEYMAPS
-- --------------------------------------
wk.add({
  { "<leader>l",  group = "[L]SP" },
  {
    "<leader>ld",
    function()
      require("telescope.builtin").diagnostics({ reuse_win = true })
    end,
    desc = "[D]iagnostics",
  },
  { "<leader>lt", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "[T]rouble Toggle" },
  { "<leader>lT", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Buffer Diagnostics (Trouble)" },
  { "<leader>ls", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols (Trouble)" },
  { "<leader>ll", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions (Trouble)", },
  { "<leader>lL", "<cmd>Trouble loclist toggle<cr>",                            desc = "Location List (Trouble)" },
  { "<leader>lq", "<cmd>Trouble qflist toggle<cr>",                             desc = "Quickfix List (Trouble)" },
  { "<leader>ly", tels.lsp_document_symbols,                                    desc = "Document S[Y]mbols" },
  { "<leader>lm", tels.lsp_dynamic_workspace_symbols,                           desc = "Workspace Sy[M]bols" },
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
    desc = "Organize [I]mports",
  },
})

-- --------------------------------------
-- SHORTCUTS
-- --------------------------------------
wk.add({
  { "<leader>s",  group = "[S]hortcuts" },
  { "<leader>sr", ":%s/\\<<C-r><C-w>\\>//g<Left><Left>",        desc = "[R]eplace All" },
  { "<leader>sc", ":%s/\\<<C-r><C-w>\\>//gc<Left><Left><Left>", desc = "[C]onfirm Replace All" },
})

-- tabs
wk.add({
  { "<leader>t",  group = "[T]abs" },
  { "<leader>te", ":tabedit",      desc = "Tab [E]dit" },
  { "<leader>tc", ":tabclose",     desc = "Tab [C]lose" },
  { "<leader>tn", ":tabnext<CR>",  desc = "[N]ext Tab" },
  { "<leader>tp", ":tabprev<CR>",  desc = "[P]rev Tab" },
})

-- --------------------------------------
-- EXTRA
-- --------------------------------------
wk.add({
  { "<leader>x",  group = "[X]tra" },
  { "<leader>xt", "<cmd>TodoTelescope<cr>",                         desc = "[T]odo" },
  { "<leader>xf", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "[F]ixme" },
  { "<leader>xn", ":NoiceLast<CR>",                                 desc = "[N]oice Last Message" },
  { "<leader>xh", ":NoiceTelescope<CR>",                            desc = "Noice [H]istory" },
  { "<leader>xl", ":Lazy<CR>",                                      desc = "[L]azy" },
  { "<leader>xm", ":Mason<CR>",                                     desc = "[M]ason" },
  { "<leader>xu", ":Telescope luasnip<CR>",                         desc = "l[U]asnip" },
  { "<leader>xs", ":SessionSave<CR>",                               desc = "[S]ession save" },
  { "<leader>xd", ":SessionDelete<CR>",                             desc = "session [D]elete" },
})

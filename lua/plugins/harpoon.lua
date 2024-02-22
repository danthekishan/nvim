return {
  "ThePrimeagen/harpoon",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("harpoon").setup({})
    require("telescope").load_extension("harpoon")
  end
}

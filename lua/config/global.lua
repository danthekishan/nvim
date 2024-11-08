-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- nerd font
vim.g.have_nerd_font = true

P = function (v)
  print(vim.inspect(v))
  return v
end

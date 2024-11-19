local conf = require("nvim-treesitter.configs")
conf.setup({
  ensure_installed = {
    "lua",
    "typescript",
    "javascript",
    "html",
    "css",
    "scss",
    "svelte",
    "c"
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

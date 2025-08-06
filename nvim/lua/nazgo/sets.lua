vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.wo.relativenumber = true
vim.wo.scrolloff = 8
vim.wo.nu = true
vim.o.incsearch = true
vim.bo.autoread = true
vim.o.hlsearch = false
vim.o.autoread = true
vim.wo.foldnestmax = 0
vim.wo.cursorline = true
vim.o.ignorecase = true
vim.o.guicursor = "n-v-c-sm:block"

-- netrw
vim.g.netrw_banner = 0
vim.g.netrw_sizestyle = "H"
vim.g.netrw_liststyle = 0
vim.g.netrw_localcopydircmd = "cp -r"
vim.g.netrw_localmkdir = "mkdir -p"
vim.g.netrw_localrmdir = "rm -r"
vim.g.netrw_sort_sequence = [[[\/]$,*]]

-- vim.cmd([[let g:prettier#autoformat = 1]])
-- vim.cmd([[let g:prettier#autoformat_require_pragma = 0]])

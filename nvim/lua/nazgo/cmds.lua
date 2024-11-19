-- html syntax for isml files
vim.cmd([[autocmd BufNewFile,BufRead *.isml set ft=html]])

-- auto file reloading when changed on disk
vim.cmd([[autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != "c" | checktime | endif]])
vim.cmd([[autocmd FileChangedShellPost *  
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None]])

-- scheming the colors
vim.cmd([[set background=dark]])
vim.cmd([[colorscheme gruber-darker]])


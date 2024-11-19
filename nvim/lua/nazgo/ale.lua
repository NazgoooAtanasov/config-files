vim.cmd([[
let g:ale_fixers = {
\   "javascript": ["eslint"],
\   "tsx": ["prettier", "eslint"],
\   "typescript": ["prettier", "eslint"],
\   "typescriptreact": ["prettier"],
\   "javascriptreact": ["prettier"],
\   "svelte": ["prettier"]
\}]])

vim.cmd([[let g:ale_fix_on_save = 1]])
vim.cmd([[let g:ale_pattern_options = { '\.isml$': {'ale_enabled': 0}, '\.c$': {'ale_enabled': 0} }]])

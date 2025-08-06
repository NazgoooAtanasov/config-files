vim.g.mapleader = " "

local function normalkeymap(key, map)
  vim.api.nvim_set_keymap("n", key, map, {})
end

-- lsp related binds
normalkeymap("gd", ":lua vim.lsp.buf.definition()<cr>")
normalkeymap("gi", ":lua vim.lsp.buf.implementation()<cr>")
normalkeymap("gr", ":lua vim.lsp.buf.references()<cr>")
normalkeymap("gt", ":lua vim.lsp.buf.type_definition()<cr>")
normalkeymap("K", ":lua vim.lsp.buf.hover()<cr>")
normalkeymap("<leader>af", ":lua vim.lsp.buf.code_action()<cr>")
normalkeymap("<leader>rn", ":lua vim.lsp.buf.rename()<cr>")
normalkeymap("<leader>dd", ":Telescope diagnostics<cr>")

-- navigational binds
normalkeymap("<leader><leader>", ":lua require('telescope.builtin').find_files(require('telescope.themes').get_ivy())<cr>")
normalkeymap("<leader>/", ":lua require('telescope').extensions.live_grep_args.live_grep_args(require('telescope.themes').get_ivy())<cr>")
normalkeymap("<leader>,", ":lua require('telescope.builtin').buffers(require('telescope.themes').get_ivy())<cr>")
normalkeymap("<leader>gg", ":G<cr>")
normalkeymap("<leader>op", ":Explore<cr>")
normalkeymap("<leader>bk", ":bd<cr>")
normalkeymap("<leader>bd", ":%bd<cr>")
normalkeymap("<leader>vs", ":vs<cr>")
normalkeymap("<leader>s", ":split<cr>")
normalkeymap("<leader>w", ":only<cr>")
normalkeymap("<leader>ht", ":Telescope help_tags<cr>")
normalkeymap("<leader>cn", ":cnext<cr>")
normalkeymap("<leader>cp", ":cprev<cr>")
normalkeymap("<leader>br", ":lua require('gitspector').branches_list()<cr>")

-- god forbid those
normalkeymap("H", "")
normalkeymap("L", "")


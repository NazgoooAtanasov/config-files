local lspconf = require("lspconfig")

lspconf.ts_ls.setup({})
-- lspconf.tailwindcss.setup({})
lspconf.svelte.setup({})
-- lspconf.emmet_ls.setup({})
lspconf.cssls.setup({})

lspconf.clangd.setup({ cmd = { "clangd", "--offset-encoding=utf-16", }, })
lspconf.hls.setup({})
lspconf.rust_analyzer.setup({})
lspconf.phpactor.setup({})
lspconf.zls.setup({})
lspconf.gopls.setup({})
lspconf.pylsp.setup({
  settings = {
    pylsp = {
      plugins = {
        pylint = { enabled = true }
      }
    }
  }
})
lspconf.gleam.setup({})
lspconf.nim_langserver.setup({})
lspconf.elixirls.setup({ cmd = { "/home/ng/_Thirdparty/elixir-ls/language_server.sh" } })
lspconf.solidity.setup({
  cmd = {'nomicfoundation-solidity-language-server', '--stdio'},
  filetypes = { 'solidity' },
  root_dir = lspconf.util.find_git_ancestor,
  single_file_support = true,
})
lspconf.gleam.setup({})


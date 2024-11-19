vim.lsp.start({
  name = "my-custom-sfcc-lsp",
  cmd = {
    vim.fn.expand("~/_Projects/sfcc-lsp/lsp")
  },
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  root_dir = vim.fs.dirname(vim.fs.find({ "main.cpp" }, { upward = true })[1])
})

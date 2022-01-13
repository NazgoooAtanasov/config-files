-- global vim.o
-- local window vim.wo
-- local buffer vim.bo
vim.wo.colorcolumn = '150'
vim.o.tabstop = 4
vim.o.shiftwidth = 4
-- vim.o.softtabstop = 4
vim.o.expandtab = true
vim.wo.relativenumber = true
vim.wo.scrolloff = 8
vim.wo.nu = true
vim.o.incsearch = true
vim.bo.autoread = true
vim.o.hlsearch = false
vim.o.autoread = true

require('packer').startup(function()
  -- treesitter and lsp
  use 'nvim-treesitter/nvim-treesitter'
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'

  -- themes
  use 'morhetz/gruvbox'

  -- goodies
  use 'jiangmiao/auto-pairs'
  use 'airblade/vim-gitgutter'
  use 'junegunn/fzf.vim'
  use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
  use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
  use 'tpope/vim-commentary'
  use 'farmergreg/vim-lastplace'

  -- completion
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  -- Telescope
  -- use {
  --   'nvim-telescope/telescope.nvim',
  --   requires = { {'nvim-lua/plenary.nvim'} }
  -- }
end)

vim.cmd([[colorscheme gruvbox]])

-- html syntax for isml files
vim.cmd([[autocmd BufNewFile,BufRead *.isml set ft=html]])

-- auto file reloading when changed on disk
vim.cmd([[autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif]])
vim.cmd([[autocmd FileChangedShellPost *
        \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None]])

local configs = require'nvim-treesitter.configs'
configs.setup {
  ensure_installed = "maintained", -- Only use parsers that are maintained
  highlight = { -- enable highlighting
    enable = true,
  },
  indent = {
    enable = true, -- default is disabled anyways
  }
}
--vim.opt.foldmethod = 'expr'
--vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
  local opts = {}
  if server.name == "sumneko_lua" then
    opts = {
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim', 'use' }
          }
        }
      }
    }
  end
  server:setup(opts)
end)

local keymap = vim.api.nvim_set_keymap
local function nkeymap(key, map)
  keymap('n', key, map, {})
end

vim.g.mapleader = " "
-- lsp keybinds
nkeymap('gd', ':lua vim.lsp.buf.definition()<cr>')
nkeymap('gD', ':lua vim.lsp.buf.declaration()<cr>')
nkeymap('gi', ':lua vim.lsp.buf.implementation()<cr>')
nkeymap('gw', ':lua vim.lsp.buf.document_symbol()<cr>')
nkeymap('gw', ':lua vim.lsp.buf.workspace_symbol()<cr>')
nkeymap('gr', ':lua vim.lsp.buf.references()<cr>')
nkeymap('gt', ':lua vim.lsp.buf.type_definition()<cr>')
nkeymap('K', ':lua vim.lsp.buf.hover()<cr>')
nkeymap('<leader>af', ':lua vim.lsp.buf.code_action()<cr>')
nkeymap('<leader>rn', ':lua vim.lsp.buf.rename()<cr>')
nkeymap('<c-k>', ':lua vim.lsp.buf.signature_help()<cr>')

-- navigation keybinds
nkeymap('<leader><leader>', ':GFiles<cr>')
nkeymap('<leader>/', ':Ag<cr>')
nkeymap('<leader>,', ':Buffers<cr>')
nkeymap('<leader>gg', ':Neogit<cr>')
nkeymap('<leader>op', ':Explore<cr>')
nkeymap('<leader>bk', ':bd<cr>')
nkeymap('<leader>bn', ':bn<cr>')
nkeymap('<leader>vs', ':vs<cr>')
nkeymap('<leader>s', ':split<cr>')
nkeymap('<c-s>', ':w<cr>')

local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  experimental = {
    native_menu = false,
    ghost_text = true
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
  }
})

cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require('lspconfig')['tsserver'].setup {
  capabilities = capabilities
}

local neogit = require('neogit')
neogit.setup {}

-- emet config
local lspconfig = require'lspconfig'
capabilities.textDocument.completion.completionItem.snippetSupport = true
if not lspconfig.emmet_ls then
  configs.emmet_ls = {
    default_config = {
      cmd = {'emmet-ls', '--stdio'};
      filetypes = {'html', 'css', 'scss', 'blade', 'isml'};
      root_dir = '~/.local/share/nvim/lsp_servers/emmet_ls',
      settings = {};
    };
  }
end
lspconfig.emmet_ls.setup{ capabilities = capabilities; }

-- status line
require('lualine').setup {
  options = {
    theme = 'gruvbox',
    section_separators = '',
    component_separators = ''
  }
}
-- global vim.o
-- local window vim.wo
-- local buffer vim.bo
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
vim.wo.foldnestmax = 0
vim.wo.cursorline = true

local packer = require 'packer'

packer.init({
    git = {
        update = 'pull --progress --rebase=true'
    },
    max_jobs = 10
})

packer.startup(function()
  -- treesitter and lsp
  use 'nvim-treesitter/nvim-treesitter'
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'onsails/lspkind-nvim'
  use 'p00f/nvim-ts-rainbow'
  use 'theprimeagen/harpoon'

  -- themes
  use {'luisiacc/gruvbox-baby', branch = 'main'}
  use 'jsit/toast.vim'
  use 'RRethy/nvim-base16'
  use 'Mofiqul/dracula.nvim'

  -- Transparency
  use 'xiyaowong/nvim-transparent'

  -- goodies
  use 'jiangmiao/auto-pairs'
  use 'airblade/vim-gitgutter'
  use 'junegunn/fzf.vim'
  use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
  use 'tpope/vim-commentary'
  use 'farmergreg/vim-lastplace'
  use 'tpope/vim-fugitive'
  use 'voldikss/vim-floaterm'
  use { 'heavenshell/vim-jsdoc', run='make install' }

  -- completion
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use {'tzachar/cmp-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-cmp'}

  -- ale lint
  use 'dense-analysis/ale'

  -- markdown
  use 'iamcco/markdown-preview.nvim'

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use 'elixir-editors/vim-elixir'
  use 'tpope/vim-endwise'
end)

vim.cmd([[colorscheme dracula]])

-- html syntax for isml files
vim.cmd([[autocmd BufNewFile,BufRead *.isml set ft=html]])

-- auto file reloading when changed on disk
vim.cmd([[autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif]])
vim.cmd([[autocmd FileChangedShellPost *
        \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None]])

local configs = require'nvim-treesitter.configs'
configs.setup {
    ensure_installed = {
        'lua',
        'typescript',
        'javascript',
        'html',
        'css',
        'scss',
        'svelte',
        'vue',
        'c'
    }, -- Only use parsers that are maintained
  highlight = { -- enable highlighting
    enable = true,
  },
  indent = {
    enable = true, -- default is disabled anyways
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil
  }
}
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

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
-- nkeymap('<leader><leader>', ':GFiles<cr>')
nkeymap('<leader><leader>', ':lua require("telescope.builtin").find_files()<cr>')
-- nkeymap('<leader>/', ':Ag<cr>')
nkeymap('<leader>/', ':lua require("telescope.builtin").live_grep()<cr>')
-- nkeymap('<leader>,', ':Buffers<cr>')
nkeymap('<leader>,', ':lua require("telescope.builtin").buffers()<cr>')
nkeymap('<leader>gg', ':G<cr>')
nkeymap('<leader>op', ':Explore<cr>')
nkeymap('<leader>bk', ':bd<cr>')
nkeymap('<leader>bd', ':%bd<cr>')
nkeymap('<leader>bn', ':bn<cr>')
nkeymap('<leader>vs', ':vs<cr>')
nkeymap('<leader>s', ':split<cr>')
nkeymap('<leader>w', ':only<cr>')
nkeymap('<leader>tt', ':FloatermNew<cr>')
nkeymap('<c-s>', ':w<cr>')

-- cool shit
nkeymap('<leader>nl', ':set nu!<cr>:set relativenumber!<cr>');
nkeymap('<leader>ll', ':set background=light<cr>:colorscheme toast<cr>:TransparentDisable<cr>');
nkeymap('<leader>bb', ':set background=dark<cr>:colorscheme gruvbox-baby<cr>:TransparentEnable<cr>');

local lspkind = require 'lspkind'
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
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'cmp_tabnine' },
    { name = 'luasnip' },
    { name = 'buffer' },
  },
    formatting = {
        format = lspkind.cmp_format {
            menu = {
                nvim_lsp = "[lsp]",
                cmp_tabnine = "[t9]",
                luasnip = "[luasnip]",
                buffer = "[buff]"
            }
        }
    }
})

local tabnine = require('cmp_tabnine.config')
tabnine:setup({
	max_lines = 1000;
	max_num_results = 20;
	sort = true;
	run_on_every_keystroke = true;
	snippet_placeholder = '..';
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

lspconfig.elixirls.setup{
  cmd = { "/home/ng/.local/share/nvim/lsp_servers/elixir/elixir-ls/language_server.sh" };
}

-- status line
require('lualine').setup {
  options = {
    theme = 'auto',
    section_separators = '',
    component_separators = ''
  }
}

require('transparent').setup({
    enable = false,
})

-- ale lint
vim.cmd([[
let g:ale_fixers = {
\   'javascript': ['eslint'],
\}]])

vim.cmd([[let g:ale_fix_on_save = 1]])

require("telescope").load_extension('harpoon')

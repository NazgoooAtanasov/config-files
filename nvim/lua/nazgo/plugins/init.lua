return {
  -- copilot
  { "github/copilot.vim" },

  -- diffview
  { "sindrets/diffview.nvim" },

  -- treesitter and lsp
  { "nvim-treesitter/nvim-treesitter" },
  { "nvim-treesitter/nvim-treesitter-context" },
  { "nvim-treesitter/playground" },
  { "neovim/nvim-lspconfig" },
  { "williamboman/nvim-lsp-installer" },
  { "onsails/lspkind-nvim" },

  -- the best color theme
  { "blazkowolf/gruber-darker.nvim" },

  -- goodies
  { "airblade/vim-gitgutter" },
  { "tpope/vim-commentary" },
  { "folke/todo-comments.nvim" },
  { "farmergreg/vim-lastplace" },
  { "tpope/vim-fugitive" },
  { "RRethy/vim-illuminate" },
  { "rush-rs/tree-sitter-asm" },
  { "mfussenegger/nvim-lint" },

  -- completion thingies
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/nvim-cmp" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-live-grep-args.nvim" }
    }
  },

  { "NazgoooAtanasov/gitspector" },
}

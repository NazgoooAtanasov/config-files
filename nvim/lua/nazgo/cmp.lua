local cmp = require("cmp")
local lspkind = require("lspkind")
local cmp_lsp = require("cmp_nvim_lsp")

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  experimental = {
    native_menu = false,
  },

  mapping = {
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),

    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),

    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),

    ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.

    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),

    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

    ["<C-t>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,

    ["<C-y>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
  },

  sources = {
    { name = "sfcc" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
  },

  formatting = {
    format = lspkind.cmp_format {
      menu = {
        nvim_lsp = "[lsp]",
        luasnip = "[luasnip]",
        buffer = "[buff]",
      }
    }
  }
})

cmp.setup.cmdline("/", {
  sources = {
    { name = "buffer" }
  }
})

cmp.setup.cmdline(":", {
  sources = cmp.config.sources(
    {
      { 
        name = "path"
      }
    },
    {
      { 
        name = "cmdline" 
      }
    }
  ) 
})

local capabilities = cmp_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

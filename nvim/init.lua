vim.o.tabstop = 4
vim.o.shiftwidth = 4
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
vim.o.mouse = false
vim.o.ignorecase = true
vim.o.guicursor = "n-v-c-sm:block"

local packer = require("packer")

packer.init({
    git = {
        update = "pull --progress --rebase=true"
    },
    max_jobs = 10
})

packer.startup(function()
    -- treesitter and lsp
    use "nvim-treesitter/nvim-treesitter"
    use 'nvim-treesitter/nvim-treesitter-context'
    use "neovim/nvim-lspconfig"
    use "williamboman/nvim-lsp-installer"
    use "jose-elias-alvarez/null-ls.nvim"
    use "onsails/lspkind-nvim"
    use "p00f/nvim-ts-rainbow"

    -- themes
    use {"luisiacc/gruvbox-baby", branch = "main"}
    use "folke/tokyonight.nvim"
    use "Mofiqul/dracula.nvim"
    use "GustavoPrietoP/doom-themes.nvim"

    -- Transparency
    use "xiyaowong/nvim-transparent"

    -- goodies
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }
    use "airblade/vim-gitgutter"
    use { "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons", opt = true } }
    use "tpope/vim-commentary"
    use "farmergreg/vim-lastplace"
    use "tpope/vim-fugitive"
    use { "heavenshell/vim-jsdoc", run="make install" }

    use "RRethy/vim-illuminate"

    -- completion
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/nvim-cmp"
    use "L3MON4D3/LuaSnip"
    use "saadparwaiz1/cmp_luasnip"

    -- ale lint
    use "dense-analysis/ale"

    -- markdown
    use 'davidgranstrom/nvim-markdown-preview'

    -- Telescope
    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            {"nvim-lua/plenary.nvim"},
            {"nvim-telescope/telescope-live-grep-args.nvim"},
        },
        config = function()
            require("telescope").load_extension("live_grep_args")
        end
    }

    use "folke/todo-comments.nvim"

    use "NazgoooAtanasov/gitspector"

    use "~/_Projects/sfcc-debugger.nvim"
    use "~/_Projects/sfcc-cartridges.nvim"
end)

-- html syntax for isml files
vim.cmd([[autocmd BufNewFile,BufRead *.isml set ft=html]])

-- auto file reloading when changed on disk
vim.cmd([[autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != "c" | checktime | endif]])
vim.cmd([[autocmd FileChangedShellPost *
        \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None]])

local configs = require"nvim-treesitter.configs"
configs.setup {
    ensure_installed = {
        "lua",
        "typescript",
        "javascript",
        "html",
        "css",
        "scss",
        "svelte",
        "vue",
        "c"
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
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
    local opts = {}
    if server.name == "lua_ls" then
        opts = {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim", "use" }
                    }
                }
            }
        }
    end
    server:setup(opts)
end)

local keymap = vim.api.nvim_set_keymap
local function nkeymap(key, map)
    keymap("n", key, map, {})
end

vim.g.mapleader = " "
-- lsp keybinds
nkeymap("gd", ":lua vim.lsp.buf.definition()<cr>")
nkeymap("gD", ":lua vim.lsp.buf.declaration()<cr>")
nkeymap("gi", ":lua vim.lsp.buf.implementation()<cr>")
nkeymap("gw", ":lua vim.lsp.buf.document_symbol()<cr>")
nkeymap("gw", ":lua vim.lsp.buf.workspace_symbol()<cr>")
nkeymap("gr", ":lua vim.lsp.buf.references()<cr>")
nkeymap("gt", ":lua vim.lsp.buf.type_definition()<cr>")
nkeymap("K", ":lua vim.lsp.buf.hover()<cr>")
nkeymap("<leader>af", ":lua vim.lsp.buf.code_action()<cr>")
nkeymap("<leader>rn", ":lua vim.lsp.buf.rename()<cr>")
nkeymap("<c-k>", ":lua vim.lsp.buf.signature_help()<cr>")
nkeymap("<leader>jd", ":JsDoc<cr>")
nkeymap("<leader>dd", ":Telescope diagnostics<cr>")

-- navigation keybinds
nkeymap("<leader><leader>", ":lua require('telescope.builtin').find_files()<cr>")
nkeymap("<leader>/", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>")
nkeymap("<leader>,", ":lua require('telescope.builtin').buffers()<cr>")
nkeymap("<leader>gg", ":G<cr>")
nkeymap("<leader>op", ":Explore<cr>")
nkeymap("<leader>bk", ":bd<cr>")
nkeymap("<leader>bd", ":%bd<cr>")
nkeymap("<leader>bn", ":bn<cr>")
nkeymap("<leader>vs", ":vs<cr>")
nkeymap("<leader>s", ":split<cr>")
nkeymap("<leader>w", ":only<cr>")
nkeymap("<leader>ht", ":Telescope help_tags<cr>")
nkeymap("<leader>cn", ":cnext<cr>")
nkeymap("<leader>cp", ":cprev<cr>")

-- cool shit
nkeymap("<leader>nl", ":set nu!<cr>:set relativenumber!<cr>");

-- gitspector <3
nkeymap("<leader>br", ":lua require('gitspector').branches_list()<cr>")

nkeymap("H", "")
nkeymap("L", "")

require('sfcc-cartridges').setup({ sourceName = "sfcc" })

local lspkind = require("lspkind")
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },

    experimental = {
        native_menu = false,
        ghost_text = true
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
        { name = "sfcc" },
        { name = "nvim_lsp" },
        -- { name = "cmp_tabnine" },
        { name = "luasnip" },
        { name = "buffer" },
    },

    formatting = {
        format = lspkind.cmp_format {
            menu = {
                nvim_lsp = "[lsp]",
                -- cmp_tabnine = "[t9]",
                luasnip = "[luasnip]",
                buffer = "[buff]",
                kur = "[kur]"
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
    sources = cmp.config.sources({
        { name = "path" }
    }, {
        { name = "cmdline" }
    })
})

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

require("lspconfig")["tsserver"].setup({
    capabilities = capabilities
})

-- emet config
local lspconfig = require("lspconfig")
local lspconfig_configs = require("lspconfig.configs")
local util = require("lspconfig.util")
capabilities.textDocument.completion.completionItem.snippetSupport = true
if not lspconfig.emmet_ls then
    configs.emmet_ls = {
        default_config = {
            cmd = {"emmet-ls", "--stdio"};
            filetypes = {"html", "css", "scss", "blade", "isml"};
            root_dir = "~/.local/share/nvim/lsp_servers/emmet_ls",
            settings = {};
        };
    }
end

lspconfig.emmet_ls.setup({ capabilities = capabilities })

lspconfig.elixirls.setup({
    cmd = { "/home/ng/.local/share/nvim/lsp_servers/elixir/elixir-ls/language_server.sh" };
})

if not lspconfig_configs.testinglsp then
    lspconfig_configs.testinglsp = {
        default_config = {
            cmd = { "/home/ng/_Projects/lsp/target/release/lsp" },
            filetypes = { "lua" },
            root_dir = util.root_pattern("Makefile", ".git", "*.gpr", "*.adc"),
            single_file_support = true,
            init_options = {
                configuration = {
                    testinglsp = { enabled = true }
                }
            },
            settings = {},
        }
    }
end
lspconfig.testinglsp.setup({})

-- status line
require("lualine").setup({
    options = {
        theme = "auto",
        section_separators = "",
        component_separators = ""
    }
})

require("transparent").setup()

-- ale lint
vim.cmd([[
let g:ale_fixers = {
\   "javascript": ["eslint"],
\   "tsx": ["eslint"],
\   "typescript": ["prettier", "eslint"],
\   "typescriptreact": ["prettier"],
\   "javascriptreact": ["prettier"]
\}]])

vim.cmd([[
let g:ale_pattern_options = {'\.isml$': {'ale_enabled': 0}}
]])

vim.cmd([[let g:ale_fix_on_save = 1]])

require("todo-comments").setup()
vim.cmd([[colorscheme gruvbox-baby]])

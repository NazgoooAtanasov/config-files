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
-- vim.o.wildmode="longest,list"

-- netrw
vim.g.netrw_banner = 0
vim.g.netrw_sizestyle = "H"
vim.g.netrw_liststyle = 0
vim.g.netrw_localcopydircmd = "cp -r"
vim.g.netrw_localmkdir = "mkdir -p"
vim.g.netrw_localrmdir = "rm -r"
vim.g.netrw_sort_sequence = [[[\/]$,*]]

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

    use "Tsuzat/NeoSolarized.nvim"
    use { "bluz71/vim-moonfly-colors", as = "moonfly" }
    use "fcpg/vim-orbital"
    use "rose-pine/neovim"

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
    use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })

    -- Telescope
    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            {"nvim-lua/plenary.nvim"},
            {"nvim-telescope/telescope-live-grep-args.nvim"},
        },
        config = function()
            local telescope = require("telescope")
            telescope.load_extension("live_grep_args")
        end
    }

    use "folke/todo-comments.nvim"
    use "folke/zen-mode.nvim"

    use "NazgoooAtanasov/gitspector"

    use "~/_Projects/sfcc-debugger.nvim"
    use "~/_Projects/sfcc-cartridges.nvim"
    use "~/_Projects/sfcc-goto.nvim"
    use "~/_Projects/sfcc-file-watcher.nvim"

    use { 'rush-rs/tree-sitter-asm' }
end)

-- html syntax for isml files
vim.cmd([[autocmd BufNewFile,BufRead *.isml set ft=html]])

-- auto file reloading when changed on disk
vim.cmd([[autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != "c" | checktime | endif]])
vim.cmd([[autocmd FileChangedShellPost *
        \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None]])

local configs = require("nvim-treesitter.configs")
configs.setup({
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
})
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

require('lspconfig').lua_ls.setup({
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})

local keymap = vim.api.nvim_set_keymap
local function nkeymap(key, map)
    keymap("n", key, map, {})
end

vim.g.mapleader = " "
-- lsp keybinds
nkeymap("gd", ":lua vim.lsp.buf.definition()<cr>")
nkeymap("gs", ":lua require('sfcc-goto').setup()<cr>")
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
nkeymap("<leader><leader>", ":lua require('telescope.builtin').find_files(require('telescope.themes').get_ivy())<cr>")
nkeymap("<leader>/", ":lua require('telescope').extensions.live_grep_args.live_grep_args(require('telescope.themes').get_ivy())<cr>")
nkeymap("<leader>,", ":lua require('telescope.builtin').buffers(require('telescope.themes').get_ivy())<cr>")
nkeymap("<leader>gg", ":G<cr>")
nkeymap("<leader>op", ":Explore<cr>")
nkeymap("<leader>bk", ":bd<cr>")
nkeymap("<leader>bd", ":%bd<cr>")
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
        { name = "luasnip" },
        { name = "buffer" },
    },

    formatting = {
        format = lspkind.cmp_format {
            menu = {
                nvim_lsp = "[lsp]",
                luasnip = "[luasnip]",
                buffer = "[buff]",
                kur = "[kur]"
            }
        }
    }
})

cmp.setup.cmdline("/", { sources = { { name = "buffer" } } })
cmp.setup.cmdline(":", { sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }) })

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

require("lspconfig").tsserver.setup({
    capabilities = capabilities
})

require("lspconfig").svelte.setup({})
require("lspconfig").clangd.setup({})
require("lspconfig").elixirls.setup({
    cmd = {"/usr/lib/elixir-ls/language_server.sh"}
})
require("lspconfig").hls.setup({})
require("lspconfig").rust_analyzer.setup({})
require("lspconfig").cssls.setup({});

-- emet config
-- local lspconfig = require("lspconfig")
-- local lspconfig_configs = require("lspconfig.configs")
-- local util = require("lspconfig.util")
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- if not lspconfig.emmet_ls then
--     configs.emmet_ls = {
--         default_config = {
--             cmd = {"emmet-ls", "--stdio"};
--             filetypes = {"html", "css", "scss", "blade", "isml"};
--             root_dir = "~/.local/share/nvim/lsp_servers/emmet_ls",
--             settings = {};
--         };
--     }
-- end
-- lspconfig.emmet_ls.setup({ capabilities = capabilities })

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
\   "javascriptreact": ["prettier"],
\   "svelte": ["prettier"]
\}]])
vim.cmd([[let g:ale_fix_on_save = 1]])
vim.cmd([[set background=dark]])
vim.cmd([[colorscheme rose-pine]])

require("todo-comments").setup()

require('telescope').setup({})

require('nvim-treesitter.parsers').get_parser_configs().asm = {
    install_info = {
        url = 'https://github.com/rush-rs/tree-sitter-asm.git',
        files = { 'src/parser.c' },
        branch = 'main',
    },
}

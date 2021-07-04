set colorcolumn=150
set expandtab
set exrc
set hidden
set incsearch
set nobackup
set nohlsearch
set noshowmode
set noswapfile
set nowrap
set nu
set relativenumber
set scrolloff=8
set shiftwidth=4
set signcolumn=yes
set smartcase
set smartindent
set tabstop=4 softtabstop=4
set termguicolors
set encoding=UTF-8
set undofile

syntax on
set t_Co=256
set cursorline
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

call plug#begin('~/.vim/plugged')
Plug 'kyazdani42/nvim-web-devicons'
Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'gruvbox-community/gruvbox'
Plug 'preservim/nerdtree'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'pangloss/vim-javascript'
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'bagrat/vim-buffet'
Plug 'neovim/nvim-lspconfig'
call plug#end()

colorscheme gruvbox

let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1
let g:buffet_powerline_separators = 1
let g:buffet_tab_icon = "\uf00a"
let g:buffet_left_trunc_icon = "\uf0a8"
let g:buffet_right_trunc_icon = "\uf0a9"

let mapleader = " "
nnoremap <leader>w :bd<CR>
nnoremap \ :NERDTreeToggle<CR>
nnoremap <leader>l $
nnoremap <leader>r cgn
nnoremap <silent><c-s> :w<CR>
nnoremap <c-a> :CocAction<CR>
nnoremap <c-i> :bn<CR>
nnoremap <c-p> :Telescope find_files<CR>
nnoremap <c-w> :bd<CR>

lua << EOF
require'lspinstall'.setup() -- important
require'lspconfig'.tsserver.setup{}

local lsp = require'lspconfig'
local util = require 'lspconfig/util'

lsp.vuels.setup {
    on_attach = function(client)
        --[[
            Internal Vetur formatting is not supported out of the box

            This line below is required if you:
                - want to format using Nvim's native `vim.lsp.buf.formatting**()`
                - want to use Vetur's formatting config instead, e.g, settings.vetur.format {...}
        --]]
        client.resolved_capabilities.document_formatting = true
        on_attach(client)
    end,
    capabilities = capabilities,
    settings = {
        vetur = {
            completion = {
                autoImport = true,
                useScaffoldSnippets = true
            },
            format = {
                defaultFormatter = {
                    html = "none",
                    js = "prettier",
                    ts = "prettier",
                }
            },
            validation = {
                template = true,
                script = true,
                style = true,
                templateProps = true,
                interpolation = true
            },
            experimental = {
                templateInterpolationService = true
            }
        }
    },
    root_dir = util.root_pattern("header.php", "package.json", "style.css", 'webpack.config.js')
}

require'telescope'.setup{
    defaults = {
       file_ignore_patterns = { "node_modules/*" },
    }
}

local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  require'lspconfig'[server].setup{}
end
EOF

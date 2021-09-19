set spell spelllang=en_us
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
" elixir BS
Plug 'amiralies/coc-elixir', {'do': 'yarn install && yarn prepack'}
Plug 'elixir-editors/vim-elixir'
Plug 'tpope/vim-endwise'

" themes
Plug 'dracula/vim'
Plug 'wadackel/vim-dogrun'
Plug 'gruvbox-community/gruvbox'

" misc
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'kyazdani42/nvim-web-devicons'
Plug 'itchyny/lightline.vim'
Plug 'xiyaowong/nvim-transparent'

" C/C++
Plug 'bfrg/vim-cpp-modern'

" the good stuff
Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'nvim-telescope/telescope.nvim'
Plug 'preservim/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'jiangmiao/auto-pairs'
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'itchyny/vim-gitbranch'
Plug 'tpope/vim-commentary'
Plug 'neovim/nvim-lspconfig'
Plug 'pangloss/vim-javascript'

" for telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'

Plug 'bagrat/vim-buffet'
call plug#end()

colorscheme dogrun

let g:ale_fixers = { 'elixir': ['mix_format'] }
let g:python3_host_prog = '/usr/bin/python3'

let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1
let g:buffet_powerline_separators = 1
let g:buffet_tab_icon = "\uf00a"
let g:buffet_left_trunc_icon = "\uf0a8"
let g:buffet_right_trunc_icon = "\uf0a9"

let g:mkdp_browser = 'brave'

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ }


let mapleader = " "
nnoremap <leader>w :bd<CR>
nnoremap \ :NERDTreeToggle<CR>
nnoremap <leader>l $
nnoremap <leader>r cgn
nnoremap <silent><c-s> :w<CR>
nnoremap <c-a> :CocAction<CR>
nnoremap <c-i> :bn<CR>
nnoremap <c-p> :Telescope find_files<CR>
nnoremap <c-o> :Telescope live_grep<CR>
nnoremap <leader>b :Telescope buffers<CR>
nnoremap <leader>c *<C-o>cgn


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

require'transparent'.setup({
  enable = true,
})

local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  require'lspconfig'[server].setup{}
end
EOF

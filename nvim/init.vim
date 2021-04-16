set colorcolumn=150
set expandtab
set exrc
set guicursor=
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
set undodir=~./.vim/undodir
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
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'gruvbox-community/gruvbox'
Plug 'gosukiwi/vim-atom-dark'
Plug 'preservim/nerdtree'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'pangloss/vim-javascript'
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'bagrat/vim-buffet'
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
nnoremap <leader>fs :Files
nnoremap \ :NERDTreeToggle<CR>
nnoremap <silent><c-s> :w<CR>
nnoremap <c-a> :CocAction<CR>
nnoremap <c-i> :bn<CR>
nnoremap <c-p> :Telescope find_files<CR>
nnoremap <c-w> :bd<CR>

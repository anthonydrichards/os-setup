" =============================================================================
" Minimal Neovim config
" =============================================================================

" ---------------------------------------------------------------------------
" GENERAL
" ---------------------------------------------------------------------------
set nocompatible
filetype plugin indent on
syntax enable

set number relativenumber
set cursorline
set termguicolors
set background=dark
set encoding=utf-8
set fileencoding=utf-8

set tabstop=4 shiftwidth=4 expandtab smartindent
set wrap linebreak
set scrolloff=8 sidescrolloff=8
set signcolumn=yes
set updatetime=250
set timeoutlen=300
set splitbelow splitright

set ignorecase smartcase
set incsearch hlsearch

set hidden
set noswapfile nobackup
set undofile

set completeopt=menuone,noselect
set clipboard=unnamedplus

" ---------------------------------------------------------------------------
" KEY MAPPINGS
" ---------------------------------------------------------------------------
let mapleader = " "

nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>e :Explore<CR>

" Clear search highlight
nnoremap <Esc> :noh<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" ---------------------------------------------------------------------------
" COLORSCHEME (habamax – ships with neovim, Solarized-like dark)
" Install a real Solarized theme via a plugin manager if desired.
" ---------------------------------------------------------------------------
colorscheme habamax

" Compatibility mode
set nocompatible " be iMproved
" BEGIN VUNDLE
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'tpope/vim-fugitive'
Plugin 'vim-ruby/vim-ruby'
Plugin 'thoughtbot/vim-rspec'
Plugin 'tpope/vim-dispatch'
Plugin 'fatih/vim-go'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'bkad/vim-terraform'
Plugin 'uarun/vim-protobuf'
Plugin 'vim-syntastic/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'plasticboy/vim-markdown'
Plugin 'elixir-editors/vim-elixir'
Plugin 'itchyny/lightline.vim'
Plugin 'neomake/neomake'
call vundle#end()
syntax on
filetype on
filetype plugin on 
filetype indent on
" END VUNDLE

" colors

" Whitespace
set nowrap
set nu
set tabstop=2 shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
syntax enable

" Disable folding
set nofoldenable

" Filetypes
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd FileType go set tabstop=4 softtabstop=4 shiftwidth=4
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd FileType python set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent fileformat=unix

"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

"" Directories for swp files
set nobackup
set noswapfile

"" Delete key should work
set backspace=indent,eol,start

"" status line
set laststatus=2


" =================== vim-terraform ========================
" Allow vim-terraform to override your .vimrc indentation syntax for matching files.
"let g:terraform_align=1
" Run terraform fmt on save.
let g:terraform_fmt_on_save=1

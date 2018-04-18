" Compatibility mode
set nocompatible " be iMproved
" BEGIN VUNDLE
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'tpope/vim-fugitive'
Plugin 'vim-ruby/vim-ruby'
Plugin 'thoughtbot/vim-rspec'
Plugin 'tpope/dispatch.vim'
Plugin 'fatih/vim-go'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'bkad/vim-terraform'
Plugin 'uarun/vim-protobuf'
Plugin 'arcticicestudio/nord-vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'plasticboy/vim-markdown'
call vundle#end()
syntax on
filetype on
filetype plugin on 
filetype indent on
" END VUNDLE

" colors
colorscheme nord

" Whitespace
set nowrap
set nu
set tabstop=2 shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
syntax enable

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

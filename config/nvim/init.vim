set spell spelllang=en_us
syntax on
" set ruler               " Show the line and column numbers of the cursor.
set formatoptions-=r formatoptions-=c formatoptions-=o    " Continue comment marker in new lines.
set textwidth=0         " Hard-wrap long lines as you type them.
set modeline            " Enable modeline.
set linespace=0         " Set line-spacing to minimum.
set nojoinspaces        " Prevents inserting two spaces after punctuation on a join (J)
set display+=lastline
set nostartofline       " Do not jump to first character with page commands.
set noerrorbells                " No beeps
set backspace=indent,eol,start  " Delete key should work
set showcmd                     " Show me what I'm typing
set showmode                    " Show current mode.
set noswapfile                  " Don't use swapfile
set nobackup            	" Don't create annoying backup files
set encoding=utf-8              " Set default encoding to UTF-8
set autowrite                   " Automatically save before :next, :make etc.
set autoread                    " Automatically reread changed files without asking me anything
set laststatus=2
set fileformats=unix,dos,mac    " Prefer Unix over Windows over OS 9 formats
set showmatch                   " Do not show matching brackets by flickering
set incsearch                   " Shows the match while typing
set hlsearch                    " Highlight found searches
set ignorecase                  " Search case insensitive...
set smartcase                   " ... but not when search pattern contains upper case characters
set autoindent
set tabstop=4 shiftwidth=4 expandtab



" cd ~/.config/nvim/spell
" wget http://ftp.vim.org/vim/runtime/spell/pt.utf-8.spl
" set spell spelllang=pt_pt
" zg to add word to word list
" zw to reverse
" zug to remove word from word list
" z= to get list of possibilities
" set spellfile=~/.config/nvim/spellfile.add
set nospell

" Plugins here
call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'vim-ruby/vim-ruby'
Plug 'thoughtbot/vim-rspec'
Plug 'tpope/dispatch.vim'
Plug 'fatih/vim-go'
Plug 'ekalinin/Dockerfile.vim'
Plug 'vim-syntastic/syntastic'
Plug 'nvie/vim-flake8'
Plug 'plasticboy/vim-markdown'
Plug 'hashivim/vim-terraform'
Plug 'airblade/vim-gitgutter'
Plug 'editorconfig/editorconfig-vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'mattn/emmet-vim'
Plug 'scrooloose/nerdtree'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
:PlugInstall
Plug 'w0rp/ale'
Plug 'neomake/neomake'
call plug#end()

" colors

" Whitespace
set wrap
set nu
set tabstop=2 shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
syntax enable

" Disable folding
set nofoldenable

"" Directories for swp files
set nobackup
set noswapfile

"" Encoding
set encoding=utf-8
set fileencodings=utf-8

" Filetypes
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd FileType go set tabstop=4 softtabstop=4 shiftwidth=4
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd FileType python set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent fileformat=unix

"" Delete key should work
set backspace=indent,eol,start


" =================== vim-terraform ========================
" Allow vim-terraform to override your .vimrc indentation syntax for matching files.
"let g:terraform_align=1
" Run terraform fmt on save.
let g:terraform_fmt_on_save=1

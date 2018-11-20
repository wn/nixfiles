" Change shell for Vundle
set shell=/bin/bash

set encoding=utf-8
set nocompatible

filetype off

" Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'w0rp/ale'
Plugin 'xolox/vim-misc'
Plugin 'majutsushi/tagbar'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
Plugin 'Raimondi/delimitMate'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'tpope/vim-surround'
Plugin 'godlygeek/tabular'
Plugin 'HTML-AutoCloseTag'
Plugin 'sbdchd/neoformat'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'Quramy/tsuquyomi'
Plugin 'mileszs/ack.vim'
Plugin 'flowtype/vim-flow'
Plugin 'sheerun/vim-polyglot' " Syntax plugins

call vundle#end()

" General settings
set backspace=indent,eol,start
set ruler
set number
set showcmd
set incsearch
set hlsearch
set shiftwidth=4
set softtabstop=4
set expandtab
set mouse=a

syntax on

filetype plugin indent on

hi clear SignColumn

set wildmenu
" Don't offer to open certain files/directories
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd
set wildignore+=node_modules/*,bower_components/*

nnoremap <Leader>e :e **/*

" Plugin-specific settings

" altercation/vim-colors-solarized settings
let g:solarized_termcolors=256

" bling/vim-airline settings
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_detect_paste = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='solarized'

" scrooloose/nerdtree
let NERDTreeMinimalUI = 1

" scrooloose/nerdcommenter
let g:NERDSpaceDelims = 1
let g:NERDTrimTrailingWhitespace = 1

" jistr/vim-nerdtree-tabs
" Open/close NERDTree Tabs with \t
nmap <silent> <leader>l :NERDTreeTabsToggle<CR>
" To have NERDTree always open on startup
" let g:nerdtree_tabs_open_on_console_startup = 1
let g:nerdtree_tabs_autoclose = 1

" w0rp/ale settings
nmap <silent> <leader>aj :ALENextWrap<cr>
nmap <silent> <leader>ak :ALEPreviousWrap<cr>
" let g:ale_sign_error = '✘'
" let g:ale_sign_warning = "▲"
" let g:airline#extensions#ale#enabled = 1
" let g:ale_linters = {
" \   'typescript': ['tslint'],
" \}

" majutsushi/tagbar settings
" Open/close tagbar with \b
nmap <silent> <leader>b :TagbarToggle<CR>

" airblade/vim-gitgutter settings
" In vim-airline, only display "hunks" if the diff is non-zero
let g:airline#extensions#hunks#non_zero_only = 1

" Raimondi/delimitMate settings
let delimitMate_expand_cr = 1
augroup mydelimitMate
    au!
    au FileType markdown let b:delimitMate_nesting_quotes = ["`"]
    au FileType tex let b:delimitMate_quotes = ""
    au FileType tex let b:delimitMate_matchpairs = "(:),[:],{:},`:'"
    au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
augroup END

" sbdchd/neoformat settings
autocmd BufWritePre *.{js,jsx,ts,tsx,vue} Neoformat
" autocmd BufWritePre *.json Neoformat
" autocmd BufWritePre *.{css,scss,less} Neoformat prettier
autocmd BufWritePre *.graphql Neoformat
autocmd BufWritePre *.{ex,exs} Neoformat

" Quramy/tsuquyomi settings
autocmd FileType typescript nmap <buffer> <Leader>t : <C-u>echo tsuquyomi#hint()<CR>

" mileszs/ack.vim settings
let g:ackprg = "ag --nogroup --nocolor --column"
nnoremap <Leader>ack :Ack!<Space>
nnoremap <Leader>acs :AckFromSearch<CR>

" add jbuilder syntax highlighting
au BufNewFile,BufRead *.json.jbuilder set ft=ruby

" flowtype/vim-flow settings
let g:flow#enable = 0 " Disable typechecking on save

" https://stackoverflow.com/a/8585343
map <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>


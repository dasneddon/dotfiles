" SPDX-License-Identifier: GPL-3.0-only
" Copyright (C) 2026 David Sneddon
" ==========================================
" General Vim Configuration
" ==========================================

set nocompatible
set encoding=utf-8

" Syntax highlighting and filetype detection
syntax enable
filetype plugin indent on

" Appearance
set number
set cursorline
set showmatch
set ruler
set laststatus=2
set showcmd
set wildmenu
set scrolloff=5
colorscheme koehler

" ==========================================
" Indentation
" ==========================================

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent

" Allow backspace across indentation and lines
set backspace=indent,eol,start

" ==========================================
" Searching
" ==========================================

set incsearch
set hlsearch
set ignorecase
set smartcase

" Clear search highlights with Ctrl-L
nnoremap <C-l> :nohlsearch<CR><C-l>

" ==========================================
" Text and Files
" ==========================================

set textwidth=79
set fileformats=unix,dos
set autoread

" ==========================================
" Filetype-specific settings
" ==========================================

augroup custom_filetypes
    autocmd!

    " Python: PEP 8 indentation
    autocmd FileType python setlocal tabstop=4
                \ softtabstop=4 shiftwidth=4 expandtab

    " Shell scripts: four-space indentation
    autocmd FileType sh setlocal tabstop=4
                \ softtabstop=4 shiftwidth=4 expandtab

    " C and C++: four-space indentation
    autocmd FileType c,cpp setlocal tabstop=4
                \ softtabstop=4 shiftwidth=4 expandtab

    " Makefiles require actual tab characters
    autocmd FileType make setlocal noexpandtab
                \ tabstop=8 shiftwidth=8

augroup END

" ==========================================
" Keyboard Shortcuts
" ==========================================

" F5: Save current file
nnoremap <F5> :write<CR>

" F7: Run Python scripts
autocmd FileType python nnoremap <buffer> <F7>
            \ :write<CR>:!python3 "%"<CR>

" F7: Run shell scripts
autocmd FileType sh nnoremap <buffer> <F7>
            \ :write<CR>:!bash "%"<CR>

" F8: Toggle line numbers
nnoremap <F8> :set number!<CR>

" F9: Toggle paste mode
nnoremap <F9> :set paste!<CR>

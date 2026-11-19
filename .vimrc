" Enable syntax highlighting for python codes
let python_highlight_all = 1
" Display line numbers in each line
set number
" Display an underline where the cursor is located
set cursorline
" Add 4 spaces for each tab
set ts=4
" Highlight the matching part of the brackets, (), {} and []
set showmatch
" It is used to control the number of tabs that will be used by vim when tab key will pressed
set softtabstop=4
"It is used to control the number of columns when left or right shift is pressed
set shiftwidth=8
"It is used for automatic text wrapping
set textwidth=79
"It is used to convert all new tab character into space
set expandtab
"It is used for adding automatic indention in vim
set autoindent
"It is used to inform vim about the file format and how to read the file
set fileformat=unix
nmap <F7> :w<cr>:!clear;"%:p"<cr>
syntax on
filetype on
colorscheme industry

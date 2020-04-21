" Setup vim plugs (call :PlugInstall to install plugins)
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

" turn on syntax highlighting
syntax on
" turn off filetype plugin/indents
filetype plugin indent off
" folding based on indentation
set foldmethod=indent
" color trailing whitespace as red
match WarningMsg /\s\+$/
" highlight characters over the 80 line length
2match Todo '\%>80v.\+'

" Show tabs and trailing spaces
set list
set listchars=tab:\|\ ,trail:•

" make tabs appear as 4 spaces
set tabstop=4
" 1 indent = 1 tab * tabstop
set shiftwidth=4
" copy the indentation from the previous line
" when starting a new line
set autoindent
" sometimes inserts one extra level of indentation
" works for C-like files
set smartindent
" show line numbers
set number

" Populate g:airline_symbols dictionary with powerline symbols
let g:airline_powerline_fonts = 1

" Set airline theme
let g:airline_theme='warmth'

" Fix missing symbols
let g:airline_symbols = {}
let g:airline_symbols.linenr = ''
let g:airline_symbols.whitespace = 'Ξ'

" set section x to the file name and modified status
let g:airline_section_x="%t%m"
" Set section y to the file type
let g:airline_section_y="%y"
" Set section z to line/lines;col
let g:airline_section_z="%l\/%L;%c"
" Make section c empty
let g:airline_section_c=""

" Show commands as they're being inputted
set showcmd

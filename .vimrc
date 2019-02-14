syntax on
colorscheme desert
" make tabs appear as 4 spaces
set tabstop=4
" 1 indent = 1 tab * tabstop
set shiftwidth=4
" Copy the indentation from the previous line
" when starting a new line
set autoindent
" sometimes inserts one extra level of indentation
" works for C-like files
set smartindent
" Show line numbers
set number
" folding based on syntax (was using indent before)
set foldmethod=indent
" Color trailing whitespace as red
match WarningMsg /\s\+$/

" Highlight characters over the 80 line len
2match Todo '\%>80v.\+'
" Show tabs as |     and trailing spaces as a dot
set list
set listchars=tab:│\ ,trail:•

" protip: view vim highlight groups with
" :so $VIMRUNTIME/syntax/hitest.vim

set showcmd
set nu
set rnu
"set clipboard=unnamed
set incsearch
let mapleader = " "

nmap <C-d> <C-d>zz
nmap <C-u> <C-u>zz

nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" idk why these don't work
nmap <C-e> <C-w>=
nmap <C-q> :q<CR>
map <C-s><C-h> <C-w>v \| <C-w>h
map <C-s><C-l> <C-w>v
map <C-s><C-j> <C-w>s

nmap <leader>va ggVG

" go implementation, go references
map gi :vsc Edit.GoToImplementation<CR>
map gr :vsc Edit.FindAllReferences<CR>

nmap <C-O> :vsc View.NavigateBackward<CR>
nmap <C-I> :vsc View.NavigateForward<CR>

noremap + :vsc Edit.CommentSelection <return>
noremap - :vsc Edit.UnCommentSelection <return>

" edit vimrc, source vimrc
nmap <leader>ev :tabnew C:\Users\Noah Burghardt\vimfiles\.vimrc<CR>
nmap <leader>sv :so C:\Users\Noah Burghardt\vimfiles\.vimrc<CR>

" project files, project search, project view
nmap <leader>pf :vsc Edit.GoToFile<CR>
nmap <leader>ps :vsc Edit.GoToText<CR>
nmap <leader>pv :vsc View.SolutionExplorer<CR>:vsc SolutionExplorer.SyncWithActiveDocument<CR>
nmap <leader>pe :vsc View.ErrorList<CR>

" open git, open tests, open references window
nmap <leader>og :vsc Team.Git.GoToGitChanges<CR>
nmap <leader>ot :vsc TestExplorer.ShowTestExplorer<CR>
nmap <leader>or :vsc View.FindReferencesWindow1<CR>

" float definition
nmap <leader>fd :vsc Edit.PeekDefinition<CR>

" sticky all, sticky clear
nmap <leader>sa :vsc View.BookmarkWindow<CR>
nmap <leader>sc :vsc Edit.ClearBookmarks<CR>

" fullscreen
nmap <leader>f :vsc View.FullScreen<CR>

" toggle wrap
nmap <leader>w :set wrap!<CR>

" go to error (ehhhh)
nmap ge :vsc View.NextError<CR>
nmap gE :vsc View.PreviousError<CR>

nnoremap n nzz
nnoremap N Nzz


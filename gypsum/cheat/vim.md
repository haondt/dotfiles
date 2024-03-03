# vim
#neovim

## :q
#quit #exit

quit

## :w
#save #write

write / save

## :wq
#save #quit #exit #write

save and quit

## s
delete character under cursor and switch to insert mode

## :PackerSync
sync packer plugins

## :so
source current file

## <leader>pf
#project

search directory files by name

## <leader>pg
#project

search all files in git directory

## <leader>ps
#project

search directory files by content

## <leader>pv
#project #directory #nvim-tree

go to file tree view

## <leader>space
search vim help with telescope view

## <A-Tab>
open buffer view

## gr
go to references

## gi
go to implementations

## <C-w>w
#toggle

cycle between open windows

## w
go to beginning of next word

## b
go to beginning of previous word

## ctrl+r
redo last command

## _
go to (indented) beginning of line

## ''
go to position before last jump

## ;
repeat latest f/F/t/T [count] times

## ,
repeat latest f/F/t/T [count] times in opposit direction

## I
go to beginning of line and switch to insert mode

## A
go to end of line and switch to insert mode

## {
go to beginning of paragraph

## }
go to end of paragraph

## ctrl+u
jump up half a page

## ctrl+d
jump down half a page

## *
go to next occurrence of word under cursor

## <octothorpe>
go to previous occurrence of word under cursor

## vi( / vi[ / vi{ / vi" / vi'
select from first '(' to matching ')'. Use with number for outer group(s)

## vip / vap
select surrounding paragraph 

## va( / va[ / va{ / va" / va'
select from first '(' to matching ')', including (). Use with number for outer group(s)

## viw / viW
select word under cursor

## ge / gE
go to end of previous word

## F+space
#combo

go to space after previous word

## <leader>p
#remap

paste without copying to buffer

## =
fix indentation of higlighted text

## o
toggle between either end of highlighted text

## J / K
#remap

move highlighted text

## ctrl+^
toggle between current and last file

## <leader>sa
#remap

toggle sticky menu

## <leader>s1 / <leader>s2 / ...
#remap #sticky

stick buffer to slot n

## <leader>1 / <leader>2 / ...
#remap #sticky

open buffer in slot n

## :TSPlaygroundToggle
#ast #highlight

see lsp syntax tree

## <C-h> <C-j> <C-k> <C-l>
#move #windows #navigate
change window focus

## <C-w-h> <C-w-j> <C-w-k> <C-w-l>
#move #windows #navigate
move windows around


change window focus

## <C-s-h/j/k/l>
#open #window

split window in direction

## <C-q>
#quit #exit

close window

## <C-e>
#resize #equal

make windows even sized

## <C-f>
#zoom #toggle

toggle window fullscreen

## <C-x>
#toggle #swap

swap window with closest

## <C-w>
toggle line wrapping

## <leader>cy
copy to system clipboard

## <leader>cp
paste from system clipboard

## <C-t>
switch to new scratch buffer

## <C-y>
#diff
toggle diff mode

## :DiffDisk
#diff
start a merge with the version of the file in the buffer with the version on disk. Run the command again to

## <leader>va
select all

## <leader>sf
set the filetype for buffer

## <leader>=
format document with lsp

## Updating
#update #sync

- `:TSUpdate` - update treesitter
- `:MasonUpdate` - update mason
- `:PackerSync` - update plugins installed with packer 

## Troubleshooting

- update everything, see above.
- `:checkhealth`
- `:LspLog`

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.linebreak = true

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.cmd('highlight SignColumn ctermbg=NONE guibg=NONE')

vim.opt.updatetime = 50
--vim.opt.colorcolumn = "80"
vim.cmd('autocmd Filetype help setlocal number')

-- global status bar
vim.opt.laststatus = 3

vim.o.diffopt = vim.o.diffopt .. ',linematch:60'
vim.o.diffopt = vim.o.diffopt .. ',foldcolumn:0'

 if vim.o.diff then
     vim.o.cursorline = true
 end

vim.opt.mouse = ''

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.breakindent = true

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = 'no'
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

vim.opt.showmode = false

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.timeout = true

-- hilight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- hilight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd('VimEnter', {
    desc = 'cd to dir when opening directory',
    group = vim.api.nvim_create_augroup('cd-to-pwd', { clear = true }),
    callback = function()
        local path = vim.fn.argv(0)
        if path and path ~= "" then
            path = path:gsub("^oil://", "")
            local dir = vim.fn.isdirectory(path) == 1 and path or vim.fn.fnamemodify(path, ":h")
            vim.notify("dir: " .. dir)
            vim.api.nvim_set_current_dir(dir)
        end
    end,
})

vim.g.mapleader = " "

-- highlight move highlighted text with J and K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- C-d & C-u are half page jumping, this just keeps the cursor centered while doing it
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keep cursor centered when iterating search
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- paste without copying pasted text
-- vim.keymap.set("x", "p", "\"_dP")

-- toggle wrapping
vim.keymap.set('n', '<leader>w', ':set wrap!<CR>')

-- copy and paste from system clipboard
vim.keymap.set("v", "<leader>cy", "\"+y")
vim.keymap.set("n", "<leader>cp", "\"+p")
vim.keymap.set("v", "<leader>cp", "\"+p")

-- window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.keymap.set('n', '<C-s><C-h>', '<C-w>v')
vim.keymap.set('n', '<C-s><C-j>', '<C-w>s<C-w>j')
vim.keymap.set('n', '<C-s><C-k>', '<C-w>s')
vim.keymap.set('n', '<C-s><C-l>', '<C-w>v<C-w>l')

vim.keymap.set('n', '<C-q>', '<C-w>q')
vim.keymap.set('n', '<C-x>', '<C-w>x')
vim.keymap.set('n', '<C-e>', '<C-w>=')

local original_layout
local function toggle_fill()
    if original_layout then
        vim.cmd(original_layout)
        original_layout = nil
    else
        original_layout = vim.fn.winrestcmd()
        vim.cmd('resize +999')
        vim.cmd('vertical resize +999')
    end
end

vim.keymap.set('n', '<C-f>', toggle_fill, { noremap = true })

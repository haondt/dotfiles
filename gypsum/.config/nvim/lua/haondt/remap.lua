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

-- select all
vim.keymap.set("n", "<leader>va", "ggVG")


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

local open_scratch_buffer = function()
    local scratch_buffer = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_option(scratch_buffer, 'bufhidden', 'delete')
    vim.api.nvim_set_current_buf(scratch_buffer)
end
vim.keymap.set('n', '<C-t>', open_scratch_buffer, { noremap = true })

vim.keymap.set('n', '<C-s><C-h>', function()
    vim.cmd('vsplit')
    open_scratch_buffer()
end)
vim.keymap.set('n', '<C-s><C-j>', function()
    vim.cmd('split')
    vim.cmd('wincmd j')
    open_scratch_buffer()
end)
vim.keymap.set('n', '<C-s><C-k>', function()
    vim.cmd('split')
    open_scratch_buffer()
end)
vim.keymap.set('n', '<C-s><C-l>', function()
    vim.cmd('vsplit')
    vim.cmd('wincmd l')
    open_scratch_buffer()
end)

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


local is_in_diff_mode = false
local toggle_diff_mode = function()
    if is_in_diff_mode then
        vim.cmd('diffoff!')
        is_in_diff_mode = false
    else
        vim.cmd('windo diffthis')
        is_in_diff_mode = true
    end
end
vim.keymap.set('n', '<C-y>', toggle_diff_mode, { noremap = true })

local set_filetype = function()
    local filetype = vim.fn.input('Enter filetype: ')
    if filetype and filetype ~= "" then
        local clients = vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf()})
        for _, client in ipairs(clients) do
            vim.lsp.buf_detach_client(0, client.id)
        end
        vim.bo.filetype = filetype
        vim.cmd('LspStart')
    else
        print('invalid or empty filetype. LSP not changed')
    end
end
vim.keymap.set('n', '<leader>sf', set_filetype, { noremap = true })

-- diagnostic

vim.keymap.set('n', '<leader>fe', vim.diagnostic.open_float, opts)

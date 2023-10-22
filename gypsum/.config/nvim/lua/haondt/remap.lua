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

-- copy and paste from system clipboard
vim.keymap.set("v", "<leader>cy", "\"+y")
vim.keymap.set("n", "<leader>cp", "\"+p")

-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- view file tree (netrw)
vim.keymap.set("n", "<leader>pv", ":Ex<CR>")

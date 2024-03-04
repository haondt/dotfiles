vim.keymap.set('x', '+',
    '<ESC><CMD>lua require("Comment.api").locked("comment.linewise")(vim.fn.visualmode())<CR>',
    { desc = 'Comment toggle linewise (visual)' })

vim.keymap.set('x', '-',
    '<ESC><CMD>lua require("Comment.api").locked("uncomment.linewise")(vim.fn.visualmode())<CR>',
    { desc = 'Comment toggle linewise (visual)' })

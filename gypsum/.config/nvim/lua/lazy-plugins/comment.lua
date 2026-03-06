return {
    'numToStr/Comment.nvim',
    opts = {
        mappings = {
            basic = false,
            extra = false
        }
    },
    keys = {
        {
            '+',
            '<ESC><CMD>lua require("Comment.api").locked("comment.linewise")(vim.fn.visualmode())<CR>',
            mode = 'x',
            desc = 'Comment toggle linewise (visual)'
        },
        {
            '-',
            '<ESC><CMD>lua require("Comment.api").locked("uncomment.linewise")(vim.fn.visualmode())<CR>',
            mode = 'x',
            desc = 'Uncomment toggle linewise (visual)'
        },
    }
}

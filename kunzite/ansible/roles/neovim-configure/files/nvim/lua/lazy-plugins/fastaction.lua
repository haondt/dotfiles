return {
    'Chaitanyabsprip/fastaction.nvim',
    opts = {
        dismiss_keys = { "<Esc>" },
        popup = {
            border = "single",
            title = false,
            highlight = {
                key = "SpecialKey"
            }
        },
        priority = {
            cs = {
                { pattern = "change namespace to", key = "c", order = 3 }
            }
        }
    }
}

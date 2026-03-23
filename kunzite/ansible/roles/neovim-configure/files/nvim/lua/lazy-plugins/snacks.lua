return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        indent = {
            enabled = true,
            indent = { enabled = false },
            animate = { enabled = false },
            scope = { enabled = true, only_current = true },
        },
        input = {
            enabled = true,
            icon = ''
        },
        words = { enabled = true },
    },
}

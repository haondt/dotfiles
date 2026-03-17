return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',
        opts = {
            ensure_installed = {
                "vimdoc", "javascript", "typescript", "c",
                "lua", "vim", "python", "query"
            },
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                disable = { "dockerfile" },
                additional_vim_regex_highlighting = { 'markdown' },
            },
        }
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },
}

return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',
        opts = {
            ensure_installed = {
            },
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                disable = { "dockerfile" },
                additional_vim_regex_highlighting = { 'markdown' },
            },
        },
        config = function(_, opts)
            require('nvim-treesitter').setup(opts)

            require('nvim-treesitter').install {
                "vimdoc", "javascript", "typescript", "c",
                "lua", "vim", "python", "query", "razor",
                "html", "css", "c_sharp", "jinja"
            }
            vim.treesitter.language.register("html", "csproj")
        end,
        init = function()
            vim.api.nvim_create_autocmd('FileType', {
                pattern = { 'cs', 'razor', 'csproj' },
                callback = function() vim.treesitter.start() end,
            })
        end
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },
}

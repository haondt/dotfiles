return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
        preset = "class",
        plugins = {
            spelling = { enabled = false },
        },
        icons = {
            breadcrumb = '',
            separator = '',
            group = '',
            mappings = false,
            keys = {
                Esc = '^E',
                Tab = '^T',
                C = '^C',
                Space = '^S',
                BS = '^B'
            }
        },
        win = {
            border = 'single',
        }
    },
    keys = {
        { '<leader>g',  group = '[g]it' },
        { '<leader>p',  group = '[p]roject actions' },
        { '<leader>o',  group = '[o]pen action on buffer' },
        { '<leader>c',  group = '[c]ode actions' },
        { '<leader>d',  group = 'start [d]iff modes' },
        { '<leader>t',  group = '[t]ext tools' },
        { '<leader>ta', group = '[t]ext [a]lign' },
        { '<leader>s',  group = '[s]ticky' },
        { 'd',          group = '[d]iff mode actions' },
        { '<C-Space>',  '<CMD>WhichKey<CR>' },
    }
}

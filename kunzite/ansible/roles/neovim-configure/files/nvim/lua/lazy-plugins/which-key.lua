
return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
        plugins = {
            spelling = { enabled = false },
        },
        icons = {
            breadcrumb = '',
            separator = '',
            group = '',
            mappings = false,
            keys = {
                Esc = 'Esc',
                Tab = 'Tab',
                Space = 'Space',
                BS = 'Backspace'
            }
        },
        win = {
            border = 'single',
        }
    },
    keys = {
        { '<leader>g', group = '[g]it' },
        { '<leader>p', group = '[p]roject actions' },
        { '<leader>o', group = '[o]pen action on buffer' },
        { '<leader>c', group = '[c]ode actions' },
        { '<leader>d', group = 'start [d]iff modes' },
        { '<leader>t', group = '[t]ext tools' },
        { '<leader>ta', group = '[t]ext [a]lign' },
        { '<leader>s', group = '[s]ticky' },
        { 'd', group = '[d]iff mode actions' },
    }
}
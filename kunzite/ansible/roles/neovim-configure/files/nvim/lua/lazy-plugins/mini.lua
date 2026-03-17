return {
    {
        'nvim-mini/mini.nvim',
        version = '*',
        config = function()
            require('mini.align').setup({
                mappings = {
                    start = '',
                    start_with_preview = '<leader>ta',
                }
            })
        end
    },
}

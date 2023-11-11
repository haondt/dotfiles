local close_telescope_picker_and_open_nvim_tree = function()
    local bufnr=vim.api.nvim_get_current_buf()
    local global_state = require('telescope.state')
    local status = global_state.get_status(bufnr)
    if status.picker then
        require('telescope.actions').close(bufnr)
    end

    vim.schedule(function ()
        vim.cmd('NvimTreeFindFile')
    end)
end

vim.keymap.set("n", "<leader>pv", close_telescope_picker_and_open_nvim_tree, { noremap = true, silent = true })


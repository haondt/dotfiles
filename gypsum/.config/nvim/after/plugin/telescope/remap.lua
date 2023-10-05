local builtin = require('telescope.builtin')
local reloader = require("plenary.reload")

vim.keymap.set('n', '<A-Tab>', builtin.buffers, {})
vim.keymap.set('n', '<leader><leader>', builtin.help_tags, {})

vim.keymap.set('n', 'gr', function() builtin.lsp_references({ initial_mode = "normal" }) end, {})
vim.keymap.set('n', 'gi', builtin.lsp_implementations, {})

vim.keymap.set('n', '<leader>pg', builtin.git_files);

local function haondt_map()
    local haondt = require('telescope').extensions.haondt
    vim.keymap.set('n', '<leader>ps', haondt.pickers.live_grep, {})
    vim.keymap.set('n', '<leader>pf', haondt.pickers.find_files, {})
end

vim.keymap.set('n', '<leader>rl', function()
 reloader.reload_module("haondt")
 reloader.reload_module("telescope")
 haondt_map()
 print('haondt-telescope reloaded.')
end);

haondt_map()

local builtin = require('telescope.builtin')
local reloader = require("plenary.reload")

local function in_normal(fn)
    return function()
        return fn({ initial_mode = "normal"})
    end
end

vim.keymap.set('n', '<A-Tab>', in_normal(builtin.buffers), {})
vim.keymap.set('n', '<leader><leader>', builtin.help_tags, {})

vim.keymap.set('n', 'gr', in_normal(builtin.lsp_references), {})
vim.keymap.set('n', 'gi', in_normal(builtin.lsp_implementations), {})
vim.keymap.set('n', 'gc', builtin.lsp_incoming_calls, {})
vim.keymap.set('n', 'gd', in_normal(builtin.lsp_definitions), {})
vim.keymap.set('n', 'gt', in_normal(builtin.lsp_type_definitions), {})

vim.keymap.set('n', '<leader>pg', builtin.git_files);
vim.keymap.set('n', '<leader>pm', builtin.lsp_workspace_symbols, {})
vim.keymap.set('n', '<leader>pe', in_normal(builtin.diagnostics), {})

vim.keymap.set('n', '<leader>oh', in_normal(builtin.git_bcommits), {})

local function haondt_map()
    local haondt = require('telescope').extensions.haondt
    vim.keymap.set('n', '<leader>ps', haondt.pickers.live_grep, {})
    vim.keymap.set('n', '<leader>pf', haondt.pickers.find_files, {})

    vim.keymap.set('n', '<leader>og', haondt.pickers.git_status, {})
end

vim.keymap.set('n', '<leader>rl', function()
 reloader.reload_module("haondt")
 reloader.reload_module("telescope")
 haondt_map()
 print('haondt-telescope reloaded.')
end);

haondt_map()

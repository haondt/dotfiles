local builtin = require('telescope.builtin')
local reloader = require("plenary.reload")

local function in_normal(fn)
    return function()
        return fn({ initial_mode = "normal"})
    end
end

vim.keymap.set('n', '<leader><Tab>', in_normal(builtin.buffers), { desc = 'list open buffers'})
vim.keymap.set('n', '<leader>ht', builtin.help_tags, { desc = 'pick [h]elp [t]ags' })
vim.keymap.set('n', '<leader>hl', builtin.highlights, { desc = 'pick [h]igh[l]ights'})

vim.keymap.set('n', 'gr', in_normal(builtin.lsp_references), {})
vim.keymap.set('n', 'gi', in_normal(builtin.lsp_implementations), {})
vim.keymap.set('n', 'gc', builtin.lsp_incoming_calls, {})
vim.keymap.set('n', 'gd', in_normal(builtin.lsp_definitions), {})
vim.keymap.set('n', 'gt', in_normal(builtin.lsp_type_definitions), {})
vim.keymap.set('n', '<leader>gw', in_normal(function() builtin.diagnostics({ bufnr = 0, severity_bound = vim.diagnostic.severity.WARN }) end), { desc = '[g]o to buffer [w]arnings'})
vim.keymap.set('n', '<leader>ge', in_normal(function() builtin.diagnostics({ bufnr = 0, severity_limit = vim.diagnostic.severity.ERROR }) end), { desc = '[g]o to buffer [e]rrors'})

vim.keymap.set('n', '<leader>pg', builtin.git_files);
vim.keymap.set('n', '<leader>pm', builtin.lsp_workspace_symbols, {})
vim.keymap.set('n', '<leader>pw', in_normal(function() builtin.diagnostics({ severity_bound = vim.diagnostic.severity.WARN }) end), { desc = 'pick [p]roject [w]arnings'})
vim.keymap.set('n', '<leader>pe', in_normal(function() builtin.diagnostics({ severity_limit = vim.diagnostic.severity.ERROR }) end), { desc = 'pick [p]roject [e]rrors'})

vim.keymap.set('n', '<leader>oh', in_normal(builtin.git_bcommits), {})

local function haondt_map()
    local haondt = require('telescope').extensions.haondt
    vim.keymap.set('n', '<leader><leader>', function() haondt.pickers.cheat({ path = "~/dotfiles/gypsum/cheat" }) end, {})
    vim.keymap.set('n', '<leader>pt', function() haondt.pickers.cheat({ path = ".", use_cheat_window = false }) end, {})
    vim.keymap.set('n', '<leader>ps', haondt.pickers.live_grep, {})
    vim.keymap.set('n', '<leader>pf', haondt.pickers.find_files, {})
    vim.keymap.set('n', '<leader>pd', function() haondt.pickers.find_files({ haondt_search_directory = true }) end, {})
    vim.keymap.set('n', '<leader>pi', function() haondt.pickers.find_files({
        haondt_search_directory = true,
        find_command = { "fdfind", "--type", "f", "--color", "never", "--hidden", "--exclude", ".git", "-I", "-L" }
    }) end, {})

    vim.keymap.set('n', '<leader>og', haondt.pickers.git_status, {})
end

vim.keymap.set('n', '<leader>rlt', function()
 reloader.reload_module("haondt")
 reloader.reload_module("telescope")
 haondt_map()
 print('haondt-telescope reloaded.')
end);

haondt_map()

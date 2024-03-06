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

vim.keymap.set('n', 'gr', in_normal(builtin.lsp_references), { desc = '[g]o to [r]eferences' })
vim.keymap.set('n', 'gi', in_normal(builtin.lsp_implementations), { desc = '[g]o to [i]mplementations' })
vim.keymap.set('n', 'gc', builtin.lsp_incoming_calls, { desc = '[g]o to incoming [c]alls' })
vim.keymap.set('n', 'gd', in_normal(builtin.lsp_definitions), { desc = '[g]o to [d]efintions' })
vim.keymap.set('n', 'gt', in_normal(builtin.lsp_type_definitions), { desc = '[g]o to [t]ype definitions' })

vim.keymap.set('n', '<leader>ow', in_normal(function() builtin.diagnostics({ bufnr = 0, severity_bound = vim.diagnostic.severity.WARN }) end), { desc = '[o]pen buffer [w]arnings'})
vim.keymap.set('n', '<leader>oe', in_normal(function() builtin.diagnostics({ bufnr = 0, severity_limit = vim.diagnostic.severity.ERROR }) end), { desc = '[o]pen buffer [e]rrors'})
vim.keymap.set('n', '<leader>os', function()
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        wrap_results = true,
        layout_strategy = 'flex',
        layout_config = {
            horizontal = {
                width = { padding = 6 },
                height = { padding = 3 },
                prompt_position = 'top',
                preview_width = 0.5,
                preview_cutoff = 50
            },
            vertical = {
                width = { padding = 6 },
                height = { padding = 3 },
                prompt_position = 'top',
                mirror = true,
                preview_cutoff = 3
            },
            flex = {
                flip_columns = 100,
            }
        }
    })
end, { desc = '[o]pen buffer fuzzy [s]earch' })


vim.keymap.set('n', '<leader>pg', builtin.git_files);
vim.keymap.set('n', '<leader>pm', builtin.lsp_workspace_symbols, {})
vim.keymap.set('n', '<leader>pw', in_normal(function() builtin.diagnostics({ severity_bound = vim.diagnostic.severity.WARN }) end), { desc = 'pick [p]roject [w]arnings'})
vim.keymap.set('n', '<leader>pe', in_normal(function() builtin.diagnostics({ severity_limit = vim.diagnostic.severity.ERROR }) end), { desc = 'pick [p]roject [e]rrors'})
vim.keymap.set('n', '<leader>pr', builtin.oldfiles, { desc = '[p]ick [r]ecent'});
vim.keymap.set('n', '<leader>pa', builtin.resume, { desc = '[p]ick [a]gain (resume)'});

vim.keymap.set('n', '<leader>gh', in_normal(builtin.git_bcommits), { desc = '[g]it [h]istory for current buffer'})

local function haondt_map()
    local haondt = require('telescope').extensions.haondt
    vim.keymap.set('n', '<leader><leader>', function() haondt.pickers.cheat({ path = "~/dotfiles/gypsum/cheat" }) end, {})
    vim.keymap.set('n', '<leader>ph', function() haondt.pickers.cheat({ path = ".", use_cheat_window = false }) end, {})
    vim.keymap.set('n', '<leader>ps', haondt.pickers.live_grep, { desc = '[p]roject [s]earch' })
    vim.keymap.set('n', '<leader>pf', haondt.pickers.find_files, {})
    vim.keymap.set('n', '<leader>pd', function() haondt.pickers.find_files({ haondt_search_directory = true }) end, {})
    vim.keymap.set('n', '<leader>pi', function() haondt.pickers.find_files({
        haondt_search_directory = true,
        find_command = { "fdfind", "--type", "f", "--color", "never", "--hidden", "--exclude", ".git", "-I", "-L" }
    }) end, {})

    vim.keymap.set('n', '<leader>gs', haondt.pickers.git_status, { desc = '[g]it [s]tatus'})
end

vim.keymap.set('n', '<leader>rlt', function()
 reloader.reload_module("haondt")
 reloader.reload_module("telescope")
 haondt_map()
 print('haondt-telescope reloaded.')
end);

haondt_map()

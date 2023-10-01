-- configure defaults
local telescope = require('telescope')
telescope.setup({
    defaults = {
        layout_strategy = 'flex',
        layout_config = {
            horizontal = {
                width = { padding = 6 },
                height = { padding = 3 },
                prompt_position = 'top',
                preview_width = 0.5
            },
            vertical = {
                width = { padding = 6 },
                height = { padding = 3 },
                prompt_position = 'top',
                mirror = true,
            }
        },
        sorting_strategy = 'ascending', }
})

-- configure results view
local entry_display = require('telescope.pickers.entry_display')
local utils = require('telescope.utils')
local make_entry = require('telescope.make_entry')
local strings = require('plenary.strings')

local live_grep_opts = {}
local live_grep_displayer = entry_display.create({
    separator = " ",
    items = {
        { remaining = true },
        { width = nil },
    }
})
live_grep_opts.entry_maker = function(line)
    local entry_maker = make_entry.gen_from_vimgrep();
    local entry = entry_maker(line);
    entry.display = function(et)
        local tail = utils.path_tail(et.filename);
        local path_without_tail = strings.truncate(et.filename, #et.filename - #tail, '');
        local path_to_display = utils.transform_path(
                { path_display = { 'truncate' } },
                path_without_tail
            );
        local unpadded_text = et.text:gsub("^%s+", "")
        return live_grep_displayer({
            { unpadded_text },
            { tail .. ' ', 'TelescopeResultsComment'}
        })
    end
    return entry;
end

-- bind windows
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', function()
    builtin.find_files();
end)
vim.keymap.set('n', '<leader>pg', function()
    builtin.git_files();
end)
--vim.keymap.set('n', '<leader>ps', function()
--	builtin.grep_string({ search = vim.fn.input("Grep > ") });
--end)
vim.keymap.set('n', '<leader>ps', function ()
    builtin.live_grep(live_grep_opts);
end);
vim.keymap.set('n', '<A-Tab>', builtin.buffers, {})
vim.keymap.set('n', '<leader><leader>', builtin.help_tags, {})

vim.keymap.set('n', 'gr', builtin.lsp_references, {})
vim.keymap.set('n', 'gi', builtin.lsp_implementations, {})

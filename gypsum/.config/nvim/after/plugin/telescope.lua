-- configure defaults
local telescope = require('telescope')
telescope.setup({
    defaults = {
        dynamic_preview_title = true,
        prompt_prefix = '~ ',
        selection_caret = ' ',
        entry_prefix = ' ',
        winblend = 0,
        border = true,
        borderchars = {
            "─",
            "│",
            "─",
            "│",
            "┌",
            "┐",
            "┘",
            "└",
        },
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
                mirror = true
            },
            flex = {
                flip_columns = 100,
            }
        },
        sorting_strategy = 'ascending', }
})

-- configure results view
local entry_display = require('telescope.pickers.entry_display')
local utils = require('telescope.utils')
local make_entry = require('telescope.make_entry')
local state = require('telescope.state')
local strings = require('plenary.strings')

local function getKeys(t)
    local keys = {}
    for k, _ in pairs(t) do
        table.insert(keys, k)
    end
    return keys
end

local live_grep_opts = {}
live_grep_opts.entry_maker = function(line)
    local entry = make_entry.gen_from_vimgrep()(line);
    local separator = " "
    --s[1] = vim.api.nvim_win_get_width(status.layout.results.winid) - #status.picker.selection_caret
    --s[2] = vim.api.nvim_win_get_height(status.layout.results.windid)
    --local fname_width = resolve.resolve_width(nil, s[1], s[2]);
    local live_grep_displayer = entry_display.create({
        separator = separator,
        items = {
            { width = nil },
            { width = nil },
        }
    })
    entry.display = function(et)
        local fn = utils.path_tail(et.filename);
        local text = et.text:gsub("^%s+", "")

        local status = state.get_status(vim.api.nvim_get_current_buf());
        --s[1] = table.concat(getKeys(status), ",")
        --local s = {}
        --s[1] = vim.api.nvim_win_get_width(status.results_win) - #status.picker.selection_caret
        --s[2] = vim.api.nvim_win_get_height(status.results_win)
        --local width = resolve.resolve_width(nil)(nil, s[1], s[2])
        local window_width = vim.api.nvim_win_get_width(status.results_win) - #status.picker.selection_caret
        local remaining_width = window_width - #fn - #separator
        local gap = remaining_width - #text

        local fn_padded = fn
        local text_truncated = text
        if gap > 0 then
            fn_padded = string.format("%s%s", string.rep(' ', gap), fn)
        elseif gap < 0 then
             text_truncated = strings.truncate(text, #text + gap)
        end

        return live_grep_displayer({
            { text_truncated },
            { fn_padded .. ' ', 'TelescopeResultsComment'}
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

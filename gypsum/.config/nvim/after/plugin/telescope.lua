
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
    return table.concat(keys, ',')
end

local live_grep_opts = {}
local make_entry_from_vimgrep = make_entry.gen_from_vimgrep()
live_grep_opts.entry_maker = function(line)
    local entry = make_entry_from_vimgrep(line);
    local separator = " "
    local displayer = entry_display.create({
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

        return displayer({
            { text_truncated },
            { fn_padded .. ' ', 'TelescopeResultsComment'}
        })
    end
    return entry;
end

local find_file_opts = { hidden = true }
find_file_opts.entry_maker = function(line)
    local fn = utils.path_tail(line)
    local path = string.sub(line, 1, -(#fn+1))
    local entry = {
        ordinal = fn,
        __fn = fn,
        __path = path,
        path = line
    }

    local displayer = entry_display.create({
        separator = "",
        items = {
            { width = nil },
            { width = nil },
        }
    })

    entry.display = function(et)
        return displayer({
            { et.__path, "TelescopeResultsComment"},
            { et.__fn }
        })
    end
    return entry;
end

local sorters = require('telescope.sorters')
local function find_file_highlighter(_, prompt, display)
    local highlights = {}
    display = display:lower()
    local fn = utils.path_tail(display)

    local search_terms = utils.max_split(prompt, "%s")
    local hl_start, hl_end

    for _, word in pairs(search_terms) do
        hl_start, hl_end = display:find(word, #display - #fn, true)
        if hl_start then
            table.insert(highlights, { start = hl_start, finish = hl_end })
        end
    end

    return highlights
end
local function get_substr_matcher()
    local file_sorter = sorters.get_substr_matcher()
    file_sorter.highlighter = find_file_highlighter
    return file_sorter
end

-- configure defaults
local telescope = require('telescope')
telescope.setup({
    defaults = {
        file_sorter = get_substr_matcher,
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

-- bind windows
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', function()
    builtin.find_files(find_file_opts);
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

local telescope = require('telescope')
local haondt = telescope.extensions.haondt

local function getKeys(t)
    local keys = {} for k, _ in pairs(t) do
        table.insert(keys, k)
    end
    return table.concat(keys, ',')
end

telescope.setup({
    defaults = {
        file_sorter = haondt.sorters.file_substr_matcher,
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
                mirror = true,
                preview_cutoff = 3
            },
            flex = {
                flip_columns = 100,
            }
        },
        sorting_strategy = 'ascending', }
})

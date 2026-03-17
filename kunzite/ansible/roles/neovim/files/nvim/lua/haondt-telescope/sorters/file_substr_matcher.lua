local utils = require('telescope.utils')
local sorters = require('telescope.sorters')

-- highlights only the named file part of the file path
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

return function()
    local file_sorter = sorters.get_substr_matcher()
    file_sorter.highlighter = find_file_highlighter
    return file_sorter
end

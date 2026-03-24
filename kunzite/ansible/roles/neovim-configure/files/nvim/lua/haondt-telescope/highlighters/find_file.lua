local utils = require('telescope.utils')

local function subsequence_positions(str, pattern)
    local positions = {}
    local si = 1
    for i = 1, #pattern do
        local ch = pattern:sub(i, i)
        local found = str:find(ch, si, true)
        if not found then return nil end
        table.insert(positions, found)
        si = found + 1
    end
    return positions
end

return function(_, prompt, display)
    local highlights = {}
    local fn = utils.path_tail(display)
    local fn_lower = fn:lower()
    local offset = #display - #fn
    local search_terms = utils.max_split(prompt, "%s")
    for _, word in pairs(search_terms) do
        local positions = subsequence_positions(fn_lower, word:lower())
        if positions then
            for _, pos in ipairs(positions) do
                table.insert(highlights, { start = offset + pos, finish = offset + pos })
            end
        end
    end
    return highlights
end

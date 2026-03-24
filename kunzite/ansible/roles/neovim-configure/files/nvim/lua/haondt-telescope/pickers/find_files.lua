local entry_display = require('telescope.pickers.entry_display')
local utils = require('telescope.utils')
local builtin = require('telescope.builtin')
local sorters = require("telescope.sorters")
local haondt_highlighters = require("haondt-telescope.highlighters")



-- displays entire file path but only searches on file name
return function(opts)
    opts = opts or {}
    opts.find_command = opts.find_command or
        { "fd", "--type", "f", "--color", "never", "--hidden", "--exclude", ".git", "-L" }

    opts.entry_maker = function(line)
        local fn = utils.path_tail(line)
        local path = string.sub(line, 1, -(#fn + 1))

        local ord = opts.haondt_search_directory and line or fn
        local entry = {
            ordinal = ord,
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
                { et.__path, "TelescopeResultsComment" },
                { et.__fn }
            })
        end
        return entry;
    end

    opts.sorter = sorters.get_fzy_sorter()
    if not opts.haondt_search_directory then
        opts.sorter.highlighter = haondt_highlighters.find_file
    end

    return builtin.find_files(opts)
end

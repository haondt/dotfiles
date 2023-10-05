local entry_display = require('telescope.pickers.entry_display')
local utils = require('telescope.utils')
local make_entry = require('telescope.make_entry')
local state = require('telescope.state')
local strings = require('plenary.strings')
local builtin = require('telescope.builtin')

local make_entry_from_vimgrep = make_entry.gen_from_vimgrep()

-- always displays the file name on the right
return function(opts)
    -- default values
    opts = opts or {}
    opts.separator = opts.separator or " "
    opts.vimgrep_arguments = {
        "rg",
        "--hidden",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case"
    }

    opts.entry_maker = function(line)
        local entry = make_entry_from_vimgrep(line)
        local displayer = entry_display.create({
            separator = opts.separator,
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
            local remaining_width = window_width - #fn - #opts.separator
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

        return entry
    end

    return builtin.live_grep(opts)
end


local entry_display = require('telescope.pickers.entry_display')
local strings = require('plenary.strings')
local state = require('telescope.state')
local Path = require("plenary.path")
local from_entry = require("telescope.from_entry")
local utils = require('telescope.utils')
local action_state = require("telescope.actions.state")
local action_set = require("telescope.actions.set")
local log = require("telescope.log")
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local haondt_previewers = require('haondt-telescope.previewers')

local last_bufnr = -1

local gen_entry_maker = function(opts)
    return function(line)
        local parts = {}
        for token in line:gmatch("([^:]+)") do
            table.insert(parts, token)
        end

        local tag = parts[1]:gsub("<COLON>", ":")
        local colstart = tonumber(parts[3])
        local colend = colstart + #tag
        local entry = {
            ordinal = tag,
            path = parts[4],
            lnum = tonumber(parts[2]),
            col = colstart,
            colend = colend,
        }

        opts.separator = opts.separator or " "
        local displayer = entry_display.create({
            separator = opts.separator,
            items = {
                { width = nil },
                { width = nil },
            }
        })

        entry.display = function(et)
            local fn = utils.path_tail(et.path);
            local text = et.ordinal:gsub("^%s+", "")

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

        return entry;
    end
end

local gen_new_finder = function(opts)
    opts.finder_command = opts.finder_command or { vim.fn.expand("~/dotfiles/gypsum/cheat/cheat.sh"), "-d", opts.path }
    local output = utils.get_os_command_output(opts.finder_command, opts.cwd)

    return finders.new_table({
        results = output,
        entry_maker = gen_entry_maker(opts)
    })
end

return function(opts)
    opts = opts or {}
    if not opts.path then
        error("opts.path required")
    end
    opts.path = vim.fn.expand(opts.path)

    opts.previewer_dyn_title = function(_, e)
        return Path:new(from_entry.path(e, false, false)):normalize(opts.path)
    end
    opts.finder = gen_new_finder(opts)
    opts.previewer = haondt_previewers.vim_buffer_vimgrep.new(opts)
    opts.layout_strategy = opts.layout_strategy or "horizontal"

    local picker = pickers.new(opts, {
        prompt_title = "Cheat",
        sorter = require("telescope.config").values.file_sorter(opts),
        attach_mappings = function(prompt_bufnr)
            -- based off the standard action_set.edit
            action_set.edit:replace(function(_, command)
                local entry = action_state.get_selected_entry()

                if not entry then
                    utils.notify("actions.set.edit", {
                        msg = "Nothing currently selected",
                        level = "WARN",
                    })
                    return
                end

                local filename, row, col

                filename = entry.path or entry.filename
                row = entry.row or entry.lnum
                col = entry.col

                local picker = action_state.get_current_picker(prompt_bufnr)
                require("telescope.pickers").on_close_prompt(prompt_bufnr)
                pcall(vim.api.nvim_set_current_win, picker.original_win_id)
                local win_id = picker.get_selection_window(picker, entry)
                if win_id ~= 0 and vim.api.nvim_get_current_win() ~= win_id then
                    vim.api.nvim_set_current_win(win_id)
                end

                local find_cheat_window = function ()
                    if last_bufnr == -1 then
                        return -1
                    elseif vim.fn.bufexists(last_bufnr) == 0 then
                        return -1
                    end

                    local windows = vim.fn.win_findbuf(last_bufnr)
                    if #windows < 0 then
                        return -1
                    end

                    return windows[1]
                end

                local cheat_open = function(path)
                    path = vim.fn.fnameescape(path)

                    -- last buffer was closed
                    local window = find_cheat_window()
                    if window == -1 then
                        last_bufnr = vim.api.nvim_create_buf(true, true)
                        vim.api.nvim_buf_set_option(last_bufnr, 'bufhidden', 'wipe')
                        vim.api.nvim_buf_set_name(last_bufnr, 'Cheat - ' .. path)
                        vim.api.nvim_buf_set_option(last_bufnr, 'syntax', 'markdown')

                        vim.cmd('sp | buffer ' .. last_bufnr)
                    -- last buffer is still open
                    else
                        vim.fn.win_gotoid(window)
                        vim.api.nvim_buf_set_option(last_bufnr, 'modifiable', true)
                        vim.api.nvim_buf_set_lines(last_bufnr, 0, -1, false, {})
                    end
                    vim.cmd('0r ' .. path)
                    vim.api.nvim_buf_set_option(last_bufnr, 'modifiable', false)
                end
                cheat_open(Path:new(filename):normalize(vim.loop.cwd()))

                local pos = vim.api.nvim_win_get_cursor(0)
                if col == nil then
                    if row == pos[1] then
                        col = pos[2] + 1
                    elseif row == nil then
                        row, col = pos[1], pos[2] + 1
                    else
                        col = 1
                    end
                end

                if row and col then
                    local ok, err_msg = pcall(vim.api.nvim_win_set_cursor, 0, { row, col })
                    if not ok then
                        log.debug("Failed to move to cursor:", err_msg, row, col)
                    end
                end
            end)

            return true
        end
    })

    picker:find()
end

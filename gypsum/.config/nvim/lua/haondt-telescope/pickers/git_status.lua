local previewers = require('telescope.previewers')
local utils = require('telescope.utils')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local sorters = require('telescope.sorters')
local pickers = require('telescope.pickers')

local gen_new_finder = function(opts)
    local git_cmd = { "git", "status", "--short", "--", ".", "-u" }
    local output = utils.get_os_command_output(git_cmd, opts.cwd)

    -- ignore the git status (D/M/??/A/etc) when sorting
    table.sort(output, function(a, b)
        local _, astr = a:match("%s*(%S+)%s*(%S+)")
        local _, bstr = b:match("%s*(%S+)%s*(%S+)")
        astr = astr or a
        bstr = bstr or b
        return astr < bstr
    end)
    return finders.new_table ({
        results = output,
        entry_maker = make_entry.gen_from_git_status(opts)
    })
end

return function (opts)
    opts = opts or {}
    if opts.cwd then
        opts.cwd = vim.fn.expand(opts.cwd)
    else
        opts.cwd = vim.loop.cwd()
    end
    local git_root, _  = utils.get_os_command_output({'git', 'rev-parse', '--show-toplevel'}, opts.cwd)
    opts.cwd = git_root[1]

    local delta = previewers.new_termopen_previewer({
        get_command = function(entry)
            if entry.status and (entry.status == '??' or entry.status == 'A ') then
                return { 'less', entry.path }
            end
            return {'git', 'diff', 'HEAD', '--', entry.path}
        end
    })

    opts.initial_mode = "normal"
    opts.layout_strategy = "vertical"
    opts.previewer = delta
    opts.attach_mappings = function(prompt_bufnr, map)
        actions.git_staging_toggle:enhance {
            post = function()
                action_state.get_current_picker(prompt_bufnr):refresh(gen_new_finder(opts), { reset_prompt = false})
            end
        }
        map({"i", "n"}, "<tab>", actions.git_staging_toggle)
        return true
    end

    -- keep selection when staging/unstaging
    opts.selection_strategy = "row"

    opts.sorter = sorters.get_fzy_sorter(opts)
    opts.finder = gen_new_finder(opts)

    local picker = pickers.new(opts)
    picker:find() -- find() will create the results window, so we can add line numbers
    vim.api.nvim_win_set_option(picker.results_win, 'relativenumber', true)
end


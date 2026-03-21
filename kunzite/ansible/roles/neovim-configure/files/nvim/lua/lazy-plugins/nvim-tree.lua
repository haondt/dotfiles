return {
    'nvim-tree/nvim-tree.lua',
    -- something with 1.16.0 breaks my on_attach, specifically the floatpreview.attach_nvimtree
    version = "1.15.0",
    lazy = false,
    dependencies = {
        { "JMarkin/nvim-tree.lua-float-preview" },
        { "nvim-telescope/telescope.nvim" },
        { dir = vim.fn.stdpath("config") .. "/lua/haondt-nvim-tree" },
    },
    config = function()
        local tree = require("nvim-tree")
        local preview = require('float-preview')
        local haondt = require('haondt-nvim-tree')
        local api = require('nvim-tree.api')

        local HEIGHT_PADDING = 4
        local WIDTH_PADDING = 6

        local Event = api.events.Event
        local clear = function()
            api.marks.clear()
            api.fs.clear_clipboard()
        end

        api.events.subscribe(Event.TreeOpen, function()
            clear()
            -- necessary in case this handler fires while closing a telescope picker
            vim.schedule(function()
                api.git.reload()
            end)
        end)

        local function on_attach(bufnr)
            local floatpreview = require('float-preview')

            floatpreview.attach_nvimtree(bufnr)
            local float_close_wrap = floatpreview.close_wrap

            local function opts(desc)
                return {
                    desc = 'nvim-tree: ' .. desc,
                    buffer = bufnr,
                    noremap = true,
                    silent = true,
                    nowait = true
                }
            end

            local function clipboard_action(action_fn)
                return function(node)
                    api.fs.clear_clipboard()
                    if api.marks.get(node) then
                        for _, marked in pairs(api.marks.list()) do
                            action_fn(marked)
                        end
                    else
                        action_fn(node)
                    end
                end
            end

            local function clear_marks_after(action_fn)
                return function()
                    action_fn()
                    api.marks.clear()
                end
            end

            vim.keymap.set('n', '<ESC>', float_close_wrap(api.tree.close), opts('Close'))
            vim.keymap.set('n', '<CR>', float_close_wrap(haondt.node.navigate.edit), opts('Edit'))
            vim.keymap.set('n', '<Tab>', haondt.node.navigate.toggle, opts('Toggle'))
            vim.keymap.set('n', 'gp', api.node.navigate.parent, opts('Go to parent'))
            vim.keymap.set('n', '<leader>h', api.node.show_info_popup, opts('Info'))
            vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
            vim.keymap.set('n', 'r', api.fs.rename_sub, opts('Rename: full'))
            vim.keymap.set('n', '<C-r>', api.fs.rename_basename, opts('Rename'))
            vim.keymap.set('n', 'y', clear_marks_after(clipboard_action(api.fs.copy.node)), opts('Copy'))
            vim.keymap.set('n', 'x', clear_marks_after(clipboard_action(api.fs.cut)), opts('Cut'))
            vim.keymap.set('n', 'p', clear_marks_after(api.fs.paste), opts('Paste'))
            vim.keymap.set('n', 'd', clear_marks_after(clipboard_action(api.fs.remove)), opts('Delete'))
            vim.keymap.set('n', 'cl', api.fs.print_clipboard, opts('Print clipboard'))
            vim.keymap.set('n', 'z', clear, opts('Clear marks and clipboard'))
            vim.keymap.set('n', 'v', api.marks.toggle, opts('Mark'))
            vim.keymap.set('n', 'bl', haondt.marks.bulk_list, opts('List marks'))
            vim.keymap.set('n', 'bd', api.marks.bulk.delete, opts('Delete marked'))
            vim.keymap.set('n', 'bv', haondt.marks.bulk_move, opts('Move marked'))
        end

        preview.setup({
            window = {
                wrap_nvimtree_commands = false,
                trim_height = false,
                open_win_config = function()
                    local screen_w = vim.opt.columns:get()
                    local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                    local window_w_f = (screen_w - WIDTH_PADDING * 2 - 1) / 2
                    local window_w = math.floor(window_w_f)
                    local window_h = screen_h - HEIGHT_PADDING * 2
                    local center_x = window_w_f + WIDTH_PADDING + 2
                    local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()

                    return {
                        style = "minimal",
                        relative = "editor",
                        border = "single",
                        row = center_y,
                        col = center_x,
                        width = window_w,
                        height = window_h
                    }
                end
            }
        })

        tree.setup({
            on_attach = on_attach,
            disable_netrw = true,
            respect_buf_cwd = true,
            sync_root_with_cwd = true,
            filters = {
                git_ignored = true,
                custom = { '^\\.git$' },
            },
            renderer = {
                indent_width = 2,
                icons = {
                    git_placement = 'after',
                    show = { file = false, folder = false },
                    glyphs = {
                        default = ' ',
                        modified = ' ',
                        hidden = '.',
                        symlink = '&',
                        bookmark = '$',
                        folder = {
                            arrow_closed = ' ',
                            arrow_open = ' ',
                            default = ' ',
                            open = ' ',
                            empty = ' ',
                            empty_open = ' ',
                            symlink = '&',
                            symlink_open = '&'
                        },
                        git = {
                            unstaged = '*',
                            staged = '+',
                            unmerged = '!',
                            untracked = '?',
                            deleted = '-',
                            ignored = '.'
                        }
                    },
                }
            },
            view = {
                relativenumber = true,
                float = {
                    enable = true,
                    open_win_config = function()
                        local screen_w = vim.opt.columns:get()
                        local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                        local window_w_f = (screen_w - WIDTH_PADDING * 2) / 2
                        local window_w = math.floor(window_w_f)
                        local window_h = screen_h - HEIGHT_PADDING * 2
                        local center_x = WIDTH_PADDING - 1
                        local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()

                        return {
                            border = "single",
                            relative = "editor",
                            row = center_y,
                            col = center_x,
                            width = window_w,
                            height = window_h,
                        }
                    end
                },
                width = function()
                    return vim.opt.columns:get() - WIDTH_PADDING * 2
                end
            },
            actions = {
                open_file = {
                    window_picker = { enable = false }
                }
            }
        })
    end,
    keys = {
        {
            "<leader>pv",
            function()
                local bufnr = vim.api.nvim_get_current_buf()
                local global_state = require('telescope.state')
                local status = global_state.get_status(bufnr)
                if status.picker then
                    require('telescope.actions').close(bufnr)
                end
                vim.cmd('NvimTreeFindFile')
            end,
            noremap = true,
            silent = true,
            desc = "Open nvim-tree"
        }
    }
}

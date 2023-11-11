local tree = require("nvim-tree")
local preview = require('float-preview')

local HEIGHT_PADDING = 3
local WIDTH_PADDING = 6

local function on_attach(bufnr)
    local api = require('nvim-tree.api')
    local floatpreview = require('float-preview')

    floatpreview.attach_nvimtree(bufnr)
    local float_close_wrap = floatpreview.close_wrap

    local Event = api.events.Event
    api.events.subscribe(Event.TreeClose, function()
        vim.schedule(function ()
            float_close_wrap(function() end)()
        end)
    end)

    local function opts(desc)
        return {
            desc = 'nvim-tree: ' .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true
        }
    end

    --api.config.mappings.default_on_attach(bufnr)
    vim.keymap.set('n', '<ESC>', api.tree.close, opts('Close'))
    vim.keymap.set('n', '<leader>fh', api.tree.close, opts('Info'))

end


preview.setup({
    window =  {
        wrap = false,
        trim_height = false,
        open_win_config = function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            local window_w_f = (screen_w - WIDTH_PADDING * 2 -1) / 2
            local window_w = math.floor(window_w_f)
            local window_h = screen_h - HEIGHT_PADDING * 2
            local center_x = window_w_f + WIDTH_PADDING + 1 + 1
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
    view = {
        relativenumber = true,
        float =  {
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
            window_picker = {
                enable = false
            }
        }
    }
})

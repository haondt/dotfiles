local popup = require("plenary.popup")
local utils = require("sticky.utils")

local M = {}

Sticky_win_id = nil
Sticky_bufh = nil

local function close_menu(force_save)
    force_save = force_save or false
    -- local global_config = Sticky.get_global_settings()
    -- if global_config.save_on_toggle or force_save then
    --     require("harpoon.ui").on_menu_save()
    -- end

    vim.api.nvim_win_close(Sticky_win_id, true)

    Sticky_win_id = nil
    Sticky_bufh = nil
end

local function create_window()
    -- local config = harpoon.get_menu_config()
    local config = {}
    local width = config.width or 60
    local height = config.height or 10
    local borderchars = config.borderchars or {
            "─",
            "│",
            "─",
            "│",
            "┌",
            "┐",
            "┘",
            "└",
    }

    local bufnr = vim.api.nvim_create_buf(false, false)
    local win_id, win = popup.create(bufnr, {
        title = "Sticky",
        highlight = "StickyWindow",
        borderhighlight = "StickyBorder2",
        titlehighlight = "StickyTitle",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor(((vim.o.columns - width) / 2)),
        minwidth = width,
        minheight = height,
        borderchars = borderchars
    })

    vim.api.nvim_win_set_option(
        win.border.win_id,
        "winhl",
        "Normal:StickyBorder"
    )

    return {
        bufnr = bufnr,
        win_id = win_id
    }
end

function M.toggle_quick_menu()
    if Sticky_win_id ~= nil and vim.api.nvim_win_is_valid(Sticky_win_id) then
        close_menu()
        return
    end

    local curr_file = utils.normalize_path(vim.api.nvim_buf_get_name(0))

    local win_info = create_window()
    local contents = {}
    -- local global_config = harpoon.get_global_settings()

    Sticky_win_id = win_info.win_id
    Sticky_bufh = win_info.bufnr

    contents[1] = "foo"
    contents[2] = "bar"
    contents[3] = "baz"

    vim.api.nvim_win_set_option(Sticky_win_id, "number", true)
    vim.api.nvim_buf_set_name(Sticky_bufh, "sticky-menu")
    vim.api.nvim_buf_set_lines(Sticky_bufh, 0, #contents, false, contents)
    vim.api.nvim_buf_set_option(Sticky_bufh, "filetype", "sticky")
    vim.api.nvim_buf_set_option(Sticky_bufh, "buftype", "acwrite")
    vim.api.nvim_buf_set_option(Sticky_bufh, "bufhidden", "delete")
    vim.api.nvim_buf_set_keymap(
        Sticky_bufh,
        "n",
        "<ESC>",
        "<Cmd>lua require('sticky.ui').toggle_quick_menu()<CR>",
        { silent = true }
    )

    -- todo: all the autocmd on_menu_save s
    --

    vim.cmd(
        "autocmd BufLeave <buffer> ++nested ++once silent lua require('sticky.ui').toggle_quick_menu()"
    )
end

return M

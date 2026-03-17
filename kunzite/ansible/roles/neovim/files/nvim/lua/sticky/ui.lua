local popup = require("plenary.popup")
local utils = require("sticky.utils")
local mark = require("sticky.mark")

local M = {}

Sticky_win_id = nil
Sticky_bufh = nil

local function close_menu(force_save)
    force_save = force_save or false
    vim.api.nvim_win_close(Sticky_win_id, true)

    Sticky_win_id = nil
    Sticky_bufh = nil
end

local function create_window()
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

    local bufnr = vim.api.nvim_create_buf(false, true)
    local win_id, win = popup.create(bufnr, {
        title = "Sticky",
        highlight = "StickyWindow",
        titlehighlight = "StickyTitle",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor(((vim.o.columns - width) / 2)),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
        cursorline = true,
        padding = {0,0,0,0}
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

local function get_or_create_buffer(file_name)
    if vim.fn.bufexists(file_name) ~= 0 then
        return vim.fn.bufnr(file_name)
    end
    return vim.fn.bufadd(file_name)
end

function M.nav_file(idx)
    if not mark.is_valid_index(idx) then
        return
    end

    local _mark = mark.list()[idx]
    if not _mark.filename then
        return
    end

    local file_name = vim.fs.normalize(_mark.filename)
    local buf_id = get_or_create_buffer(file_name)
    local set_pos = not vim.api.nvim_buf_is_loaded(buf_id)
    local old_bufnr = vim.api.nvim_get_current_buf()

    vim.api.nvim_set_current_buf(buf_id)
    vim.api.nvim_buf_set_option(buf_id, "buflisted", true)
    if set_pos and _mark.row and _mark.col then
        vim.cmd(string.format(":call cursor(%d, %d)", _mark.row, _mark.col))
    end

    local old_bufinfo = vim.fn.getbufinfo(old_bufnr)
    if type(old_bufinfo) == "table" and #old_bufinfo >= 1 then
        old_bufinfo = old_bufinfo[1]
        local no_name = old_bufinfo.name == ""
        local one_line = old_bufinfo.linecount == 1
        local unchanged = old_bufinfo.changed == 0
        if no_name and one_line and unchanged then
            vim.api.nvim_buf_delete(old_bufnr, {})
        end
    end
end

function M.select_menu_item()
    local idx = vim.fn.line(".")
    close_menu()
    M.nav_file(idx)
end

function M.toggle_quick_menu()
    if Sticky_win_id ~= nil and vim.api.nvim_win_is_valid(Sticky_win_id) then
        close_menu()
        return
    end

    local current = utils.current_relative_path()
    vim.cmd(
        string.format(
            "autocmd Filetype sticky "
                .. "let path = '%s' | call clearmatches() | "
                .. "call search('\\V'.path.'\\$') | "
                .. "call matchadd('StickyCurrentFile', '\\V'.path.'\\$')",
            current:gsub("\\", "\\\\")
        )
    )

    local win_info = create_window()
    Sticky_win_id = win_info.win_id
    Sticky_bufh = win_info.bufnr

    local contents = {}
    local marks = mark.list()
    for idx, _mark in ipairs(marks) do
        contents[idx] = string.format("%s", _mark.filename or "")
    end

    vim.api.nvim_win_set_option(Sticky_win_id, "number", true)
    vim.api.nvim_buf_set_name(Sticky_bufh, "sticky-menu")
    vim.api.nvim_buf_set_lines(Sticky_bufh, 0, #contents, false, contents)
    vim.api.nvim_buf_set_option(Sticky_bufh, "filetype", "sticky")
    vim.api.nvim_buf_set_option(Sticky_bufh, "buftype", "nofile")
    vim.api.nvim_buf_set_option(Sticky_bufh, "modifiable", false)
    vim.api.nvim_buf_set_option(Sticky_bufh, "bufhidden", "delete")
    vim.api.nvim_buf_set_keymap(
        Sticky_bufh,
        "n",
        "<ESC>",
        "<Cmd>lua require('sticky.ui').toggle_quick_menu()<CR>",
        { silent = true }
    )

    vim.api.nvim_buf_set_keymap(
        Sticky_bufh,
        "n",
        "<CR>",
        "<Cmd>lua require('sticky.ui').select_menu_item()<CR>",
        {}
    )



    -- todo: all the autocmd on_menu_save s
    --

    vim.cmd(
        "autocmd BufLeave <buffer> ++nested ++once silent lua require('sticky.ui').toggle_quick_menu()"
    )
end

return M

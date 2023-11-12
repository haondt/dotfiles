local marks = require('nvim-tree.marks')
local notify = require('nvim-tree.notify')
local utils = require("nvim-tree.utils")
local rename_file = require('nvim-tree.actions.fs.rename-file')

local M = {}

local function wrap_node(fn)
    return function(node, ...)
        node = node or require('nvim-tree.lib').get_node_at_cursor()
        if node then
            fn(node, ...)
        end
    end
end

local bulk_move = function(node)
    if #marks.get_marks() == 0 then
        notify.warn("No marks to move")
        return
    end

    local target = node.absolute_path
    if vim.fn.isdirectory(target) ~= 1 then
        target = vim.fn.fnamemodify(target, ":h")
    end

    if vim.fn.filewritable(target) ~= 2 then
        notify.warn(target .. " is not writeable, cannot move.")
        return
    end

    local nodes = marks.get_marks()
    for _, node in pairs(nodes) do
        local head = vim.fn.fnamemodify(node.absolute_path, ":t")
        local to = utils.path_join({ target, head })
        rename_file.rename(node, to)
    end

    marks.clear_marks()

    if not require('nvim-tree.marks.bulk-move').config.filesystem_watchers.enable then
        require('nvim-tree.actions.reloaders.reloaders').reload_explorer()
    end
end

local bulk_list = function()
    if #marks.get_marks() == 0 then
        notify.warn("No marks to list")
        return
    end

    local s = ""
    local nodes = marks.get_marks()
    for _, node in pairs(nodes) do
        s = s .. node.absolute_path .. '\n'
    end

    vim.api.nvim_echo({{s, 'Normal'}}, true, {})
end


M.bulk_move = wrap_node(bulk_move)
M.bulk_list = bulk_list

return M

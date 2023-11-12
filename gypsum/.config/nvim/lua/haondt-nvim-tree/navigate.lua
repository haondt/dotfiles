local marks = require('nvim-tree.marks')
local notify = require('nvim-tree.notify')
local utils = require("nvim-tree.utils")
local rename_file = require('nvim-tree.actions.fs.rename-file')
local parent = require('nvim-tree.actions.moves.parent')
local lib = require('nvim-tree.lib')

local M = {}


local function wrap_node(fn)
    return function(node, ...)
        node = node or lib.get_node_at_cursor()
        if node then
            fn(node, ...)
        end
    end
end

local toggle = function(node)
    if node.name == ".." then
        return
    end


    if node.nodes then
        lib.expand_or_collapse(node)
        return
    end

    parent.fn(true)(node)
end

local edit = function(node)
    if node.name == ".." then
        return
    end

    if node.nodes then
        return
    end

    local path = node.absolute_path
    if node.link_to then
        path = node.link_to
    end
    require('nvim-tree.actions.node.open-file').fn('edit', path)
end

M.toggle = wrap_node(toggle)
M.edit = wrap_node(edit)

return M

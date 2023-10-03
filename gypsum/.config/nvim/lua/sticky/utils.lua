local Path = require("plenary.path")

local M = {}

function M.project_key()
    return vim.loop.cwd()
end

function M.normalize_path(item)
    return Path:new(item):make_relative(M.project_key())
end

return M

local Path = require("plenary.path")

local M = {}

function M.current_relative_path()
    local current_file_name = vim.api.nvim_buf_get_name(0)
    return Path:new(current_file_name):make_relative(M.current_project_key())
end

function M.current_project_key()
    return vim.loop.cwd()
end
function M.normalize_path(item)
    return Path:new(item):make_relative(M.project_key())
end

-- t2 will overwrite t1
function M.merge_tables(t1, t2)
    for k, v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k]) == "table" then
                M.merge_tables(t1[k], v)
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
end

return M

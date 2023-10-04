local utils = require("sticky.utils")
local sticky = require("sticky")

local M = {}

local function filter_filetype()
    local current_filetype = vim.bo.filetype
    if current_filetype == "sticky" then
        error("You can't sticky sticky")
        return
    end
end

local function get_index_of(file_name, marks)
    for idx = 1, #marks do
        if marks[idx] and marks[idx].filename == file_name then
            return idx
        end
    end
    return nil
end

function M.is_valid_index(idx, marks)
    local settings = sticky.get_settings()
    return idx ~= nil and idx >= 1 and idx <= settings.num_slots
end

    --local mark = marks[idx]
    --return mark and mark.filename and mark.filename ~= ""

function M.stick_current(target_idx)
    filter_filetype()
    local file_name = utils.current_relative_path()
    local project_key = utils.current_project_key()

    if file_name == nil or file_name == "" or project_key == nil or project_key == "" then
        return
    end

    local project = sticky.get_project(project_key)
    local marks = project.mark.marks

    --local current_idx = get_index_of(file_name, marks)
    if M.is_valid_index(target_idx, marks) then
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        marks[target_idx] = {
            filename = file_name,
            row = cursor_pos[1],
            col = cursor_pos[2],
        }
    end

    sticky.save()
end

function M.list()
    local project_key = utils.current_project_key()
    local project = sticky.get_project(project_key)
    return project.mark.marks
end

return M

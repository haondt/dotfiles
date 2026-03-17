local Path = require("plenary.path")
local utils = require("sticky.utils")

-- local config_path
local data_dir = vim.fn.stdpath("data") -- echo stdpath("data")
local data_path = string.format("%s/sticky.json", data_dir)
local data_version = "1"


local M = {}

StickyData = StickyData or {}

local function read_data(path)
    return vim.json.decode(Path:new(path):read())
end

local function refresh_other_projects()
    local project_key = utils.current_project_key()
    local partial_data = {
        projects = {
            [project_key] = M.get_project(project_key)
        }
    }

    -- refresh projects from disk
    StickyData.projects = nil
    local has_data, loaded_data = pcall(read_data, data_path)
    if not has_data then
        loaded_data = { projects = {} }
    end

    -- extract only the projects from loaded data
    loaded_data = { projects = loaded_data.projects }
    -- delete the stale data of current project
    loaded_data.projects[project_key] = nil

    utils.merge_tables(partial_data, loaded_data)
    utils.merge_tables(StickyData, partial_data)
end

function M.save()
    refresh_other_projects()
    Path:new(data_path):write(vim.fn.json_encode(StickyData), "w")
end

function M.get_project(project_key)
    local projects = StickyData.projects

    if projects[project_key] == nil then
        projects[project_key] = {}
    end

    local project = projects[project_key]
    if project.mark == nil then
        project.mark = { marks = {} }
    end

    local marks = project.mark.marks
    local settings = StickyData.settings
    while #marks < settings.num_slots do
        table.insert(marks, {})
    end
    while #marks > settings.num_slots do
        table.remove(marks)
    end

    return project
end

function M.get_settings()
    return StickyData.settings
end

function M.upsert_project(project_key, project)
    StickyData.projects[project_key] = project
end

function M.setup()
    StickyData = {
        data_version = data_version,
        projects = {},
        settings = {
            num_slots = 8
        }
    }

    local has_data, loaded_data = pcall(read_data, data_path)
    if has_data then
        utils.merge_tables(StickyData, loaded_data)
    end
end


M.setup()

return M

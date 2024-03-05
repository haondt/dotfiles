local lualine = require('lualine')
local Path = require("plenary.path")
local palette = require("haondt.colors").palette

local function normalized_path()
    return Path:new(vim.api.nvim_buf_get_name(0)):make_relative(vim.loop.cwd())
end

local function current_file()
    return vim.fn.expand('%:t')
end

local function lsp_status()
    local s = ''
    s = '?'
    local clients = vim.lsp.get_active_clients({
        bufnr=vim.api.nvim_get_current_buf()
    })
    if clients ~= nil and #clients > 0 then
        s = ''
        for _, client in ipairs(clients) do
            local cs = client.name
            if not client.initialized then
                cs = '+' .. cs
            else
                local has_pending = false
                for _,v in pairs(client.requests) do
                    if v.type and v.type == "pending" then
                        has_pending = true
                        break
                    end
                end

                if has_pending then
                    cs = '*' .. cs
                else
                    cs = ' ' .. cs
                end
            end

            if #s > 0 then
                s = s .. ' ' .. cs
            else
                s = cs
            end
        end
    end
    return s
end

local theme = {
    replace = {
        a = { bg = palette.color6, fg = palette.color5, gui = 'bold' },
        b = { bg = palette.color5, fg = palette.color14 },
        c = { bg = palette.bg, fg = palette.color15 },
        x = { bg = palette.bg, fg = palette.color15, gui = 'bold' },
        y = { bg = palette.color13, fg = palette.color7 },
        z = { bg = palette.color5, fg = palette.color15 }
    },
    normal = {
        a = { bg = palette.color9, fg = palette.color11, gui = 'bold' },
        b = { bg = palette.color6, fg = palette.color7 },
        c = { bg = palette.bg, fg = palette.color15 },
        x = { bg = palette.bg, fg = palette.color15, gui = 'bold' },
        y = { bg = palette.color14, fg = palette.color7 },
        z = { bg = palette.color1, fg = palette.color11 }
    },
    visual = {
        a = { bg = palette.color12, fg = palette.color4, gui = 'bold' },
        b = { bg = palette.color4, fg = palette.color15 },
        c = { bg = palette.bg, fg = palette.color15 },
        x = { bg = palette.bg, fg = palette.color15, gui = 'bold' },
        y = { bg = palette.color12, fg = palette.color5 },
        z = { bg = palette.color6, fg = palette.color7 }
    },
    command = {
        a = { bg = palette.color13, fg = palette.color15 , gui = 'bold' },
        b = { bg = palette.color5, fg = palette.color15 },
        c = { bg = palette.bg, fg = palette.color15 },
        x = { bg = palette.bg, fg = palette.color15, gui = 'bold' },
        y = { bg = palette.color12, fg = palette.color7 },
        z = { bg = palette.color5, fg = palette.color15 }
    },
    insert = {
        a = { bg = palette.color0, fg = palette.color11, gui = 'bold' },
        b = { bg = palette.color8, fg = palette.color7 },
        c = { bg = palette.bg, fg = palette.color15 },
        x = { bg = palette.bg, fg = palette.color15, gui = 'bold' },
        y = { bg = palette.color11, fg = palette.color7 },
        z = { bg = palette.color3, fg = palette.color7 }
    },
    inactive = {
        a = { bg = palette.color7, fg = palette.color7, gui = 'bold' },
        b = { bg = palette.color0, fg = palette.color7 },
        c = { bg = palette.color7, fg = palette.color15 },
        x = { bg = palette.bg, fg = palette.color15, gui = 'bold' },
        y = { bg = palette.color7, fg = palette.color8 },
        z = { bg = palette.color0, fg = palette.color0 }
    },
}

lualine.setup {
    options = {
        theme = theme,
        refresh = {
            statusline = 500
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { current_file },
        lualine_c = { {
            'diagnostics',
            symbols = { error = '!', warn = '?', info = 'i', hint = '*'  }
        } },
        lualine_x = { lsp_status },
        lualine_y = { vim.loop.cwd },
        lualine_z = { 'progress' },
    },
    inactive_sections = {
        lualine_a = { function() return " " end },
        lualine_b = { current_file },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { vim.loop.cwd },
        lualine_z = { function() return " " end },
    },
}

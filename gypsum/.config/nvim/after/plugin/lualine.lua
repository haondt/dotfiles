local lualine = require('lualine')
local Path = require("plenary.path")
local palette = require("haondt.colors").palette

local lsp_progress = {
    'lsp_progress',
    display_components = {
        --'lsp_client_name',
        'spinner'
    },
    colors = { use = false },
    separators = {
        component = '',
        lsp_client_name = { pre = '', post = '' },
        spinner = { pre = '', post = ''}
    },
    timer = {
        progress_enddelay = 0,
        spinner = 250,
        lsp_client_name_enddelay = 0,
        attached_delay = 0
    },
	--spinner_symbols = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█', '▇', '▆', '▅', '▄', '▃', '▁' }
    --spinner_symbols = { '\\', '|', '/', '-' }
    --spinner_symbols = {'⠁', '⠂', '⠄', '⡀', '⢀', '⠠', '⠐', '⠈'}
    spinner_symbols = { '⢎⡰', '⢎⡡', '⢎⡑', '⢎⠱', '⠎⡱', '⢊⡱', '⢌⡱', '⢆⡱' }
}

local function normalized_path()
    return Path:new(vim.api.nvim_buf_get_name(0)):make_relative(vim.loop.cwd())
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
        b = { bg = palette.color10, fg = palette.color7 },
        c = { bg = palette.bg, fg = palette.color15 },
        x = { bg = palette.bg, fg = palette.color15, gui = 'bold' },
        y = { bg = palette.color2, fg = palette.color15 },
        z = { bg = palette.color5, fg = palette.color15 }
    },
    _visual = {
        a = { bg = palette.color11, fg = palette.color7, gui = 'bold' },
        b = { bg = palette.color8, fg = palette.color5, gui = 'bold' },
        c = { bg = palette.bg, fg = palette.color15 },
        x = { bg = palette.bg, fg = palette.color15, gui = 'bold' },
        y = { bg = palette.color3, fg = palette.color7 },
        z = { bg = palette.color7, fg = palette.color8 }
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
        lualine_b = { lsp_progress, normalized_path },
        lualine_c = { 'diagnostics' },
        lualine_x = {},
        lualine_y = { vim.loop.cwd },
        lualine_z = { 'progress' },
    },
    inactive_sections = {
        lualine_a = { function() return " " end },
        lualine_b = { normalized_path },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { vim.loop.cwd },
        lualine_z = { function() return " " end },
    },
}

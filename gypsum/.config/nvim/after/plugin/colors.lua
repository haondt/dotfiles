
local M = {}
M.colors = {
    -- special
    none = "NONE",
    bg = "#0b0708",
    fg = "#f3c6b1",

    -- black
    color0 = "#8e6c51",
    color8 = "#b89f8b",

    -- red
    color1 = "#d44e45",
    color9 = "#cc6666",

    -- green
    color2 = "#8d479e",
    color10 = "#ad73bb",

    -- yellow
    color3 = "#fcb685",
    color11 = "#fcd1b3",

    -- blue
    color4 = "#c46692",
    color12 = "#dfa0bd",

    -- magenta
    color5 = "#7b3a66",
    color13 = "#a15488",

    -- cyan
    color6 = "#d98887",
    color14 = "#f3afaf",

    -- white
    color7 = "#3e2d34",
    color15 = "#eacfda",
}

M.palette = {
    none = M.colors.none,
    bg = M.colors.none,
    fg = M.colors.fg,
    color0 = M.colors.color0,
    color1 = M.colors.color1,
    color2 = M.colors.color2,
    color3 = M.colors.color3,
    color4 = M.colors.color4,
    color5 = M.colors.color5,
    color6 = M.colors.color6,
    color7 = M.colors.color7,
    color8 = M.colors.color8,
    color9 = M.colors.color9,
    color10 = M.colors.color10,
    color11 = M.colors.color11,
    color12 = M.colors.color12,
    color13 = M.colors.color13,
    color14 = M.colors.color14,
    color15 = M.colors.color15,

    selected = M.colors.color7,
}

function ColorMyPencils(palette)
	--vim.cmd.colorscheme(color)
	vim.api.nvim_set_hl(0, "Normal", { bg = palette.bg, fg = palette.fg  })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = palette.bg })
	vim.api.nvim_set_hl(0, "Visual", { bg = palette.selected })

    -- telescope
	vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = palette.none, fg = palette.fg  })
	vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = palette.color10  })
	vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = palette.fg  })
	vim.api.nvim_set_hl(0, "TelescopePromptCounter", { fg = palette.color10 })
    vim.api.nvim_set_hl(0, "TelescopeResultsComment", { fg = palette.color0})
    vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = palette.color9, underline = true })

end

ColorMyPencils(M.palette)

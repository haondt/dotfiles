function ColorMyPencils(palette)
	--vim.cmd.colorscheme(color)
	vim.api.nvim_set_hl(0, "Normal", { bg = palette.bg, fg = palette.fg  })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = palette.bg })
	vim.api.nvim_set_hl(0, "Visual", { bg = palette.selected })
	vim.api.nvim_set_hl(0, "Cursorline", { bg = palette.color7 })


    -- telescope
	vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = palette.none, fg = palette.fg  })
	vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = palette.color10  })
	vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = palette.fg  })
	vim.api.nvim_set_hl(0, "TelescopePromptCounter", { fg = palette.color10 })
    vim.api.nvim_set_hl(0, "TelescopeResultsComment", { fg = palette.color0})
    vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = palette.color9, underline = true })
    vim.api.nvim_set_hl(0, "TelescopePreviewLine", { bg = palette.color5 })

    -- sticky
    vim.api.nvim_set_hl(0, "StickyWindow", { bg = palette.none })
    vim.api.nvim_set_hl(0, "StickyTitle", { fg = palette.fg })
    vim.api.nvim_set_hl(0, "StickyBorder", { fg = palette.color10, bg = palette.none })
    vim.api.nvim_set_hl(0, "StickyCurrentFile", { fg = palette.color9 })

end

local colors = require("haondt.colors")
ColorMyPencils(colors.palette)

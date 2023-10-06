local colors = require("haondt.colors")
local palette = colors.palette
--colors.colors.bg

--vim.cmd.colorscheme(color)
vim.api.nvim_set_hl(0, "Normal", { bg = palette.bg, fg = palette.fg  })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = palette.bg })
vim.api.nvim_set_hl(0, "Visual", palette.selected)
vim.api.nvim_set_hl(0, "Cursorline", palette.selected)
vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = palette.color3 })
vim.api.nvim_set_hl(0, "Directory", { fg = palette.color4, bold = true })
vim.api.nvim_set_hl(0, "ErrorMsg", palette.error)
vim.api.nvim_set_hl(0, "ErrorMsg", palette.error)
vim.api.nvim_set_hl(0, "Search", palette.search)
vim.api.nvim_set_hl(0, "IncSearch", palette.search)
vim.api.nvim_set_hl(0, "LineNr", { fg = palette.color6 })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = palette.color14 })

-- diagnostics
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = palette.error.bg })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { sp = palette.error.bg, underline = true })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = palette.color3 })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { sp = palette.color3, underline = true })
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = palette.color11 })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { sp = palette.color11, underline = true })

-- lsp colors
--vim.api.nvim_set_hl(0, "Type", { fg = palette.color9, bold = true })
--
vim.api.nvim_set_hl(0, "Error", palette.error)

-- public, private, string
vim.api.nvim_set_hl(0, "Type", { fg = palette.color8 })

-- MyClass, Task, [FromBody]
vim.api.nvim_set_hl(0, "Structure", { fg = palette.color6, bold = true })

-- interfaces
vim.api.nvim_set_hl(0, "@lsp.type.interface", { fg = palette.color11 })

-- namespace, class, async, =
vim.api.nvim_set_hl(0, "Statement", { fg = palette.color8 })

-- [], (), {}, :,
vim.api.nvim_set_hl(0, "Special", { fg = palette.color8 })

-- _privateVariable, declaredVariable
vim.api.nvim_set_hl(0, "Identifier", { fg = palette.color15 })

-- readonly
vim.api.nvim_set_hl(0, "StorageClass", { fg = palette.color8 })

-- "string"
vim.api.nvim_set_hl(0, "String", { fg = palette.color9 })

-- argumentVariable
vim.api.nvim_set_hl(0, "@lsp.type.parameter", { fg = palette.color10 })

-- // comment
vim.api.nvim_set_hl(0, "Comment", { fg = palette.fg })

-- Method()
vim.api.nvim_set_hl(0, "Function", { fg = palette.color4, bold = true })

-- EnumMember
vim.api.nvim_set_hl(0, "@lsp.type.enumMember", { fg = palette.color3 })

-- true
vim.api.nvim_set_hl(0, "Constant", { fg = palette.color11, bold = true })

-- 0, 1.2
vim.api.nvim_set_hl(0, "Number", { fg = palette.color11, bold = true })

-- using
vim.api.nvim_set_hl(0, "PreProc", { fg = palette.color8 })

-- This.Is.The.Namespace
vim.api.nvim_set_hl(0, "@lsp.type.namespace", { fg = palette.color0 })


--vim.api.nvim_set_hl(0, "Typedef", { fg = palette.color15 })


-- telescope
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = palette.none, fg = palette.fg  })
vim.api.nvim_set_hl(0, "TelescopeBorder", palette.popup_border)
vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = palette.fg  })
vim.api.nvim_set_hl(0, "TelescopePromptCounter", { fg = palette.color10 })
vim.api.nvim_set_hl(0, "TelescopeResultsComment", { fg = palette.color0})
vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = palette.color9, underline = true })
vim.api.nvim_set_hl(0, "TelescopePreviewLine", palette.search)

-- sticky
vim.api.nvim_set_hl(0, "StickyWindow", { bg = palette.bg })
vim.api.nvim_set_hl(0, "StickyTitle", { fg = palette.fg })
vim.api.nvim_set_hl(0, "StickyBorder", palette.popup_border)
vim.api.nvim_set_hl(0, "StickyCurrentFile", { fg = palette.color9 })

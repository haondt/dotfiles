local reloader = require("plenary.reload")

local function map()
    local ui = require("sticky.ui")
    local mark = require("sticky.mark")
    vim.keymap.set("n", "<leader>sa", ui.toggle_quick_menu)

    vim.keymap.set("n", "<leader>s1", function() mark.stick_current(1) end)
    vim.keymap.set("n", "<leader>s2", function() mark.stick_current(2) end)
    vim.keymap.set("n", "<leader>s3", function() mark.stick_current(3) end)
    vim.keymap.set("n", "<leader>s4", function() mark.stick_current(4) end)
end
map()

vim.keymap.set('n', '<leader>srl', function()
 reloader.reload_module("sticky")
 map()
 print('sticky reloaded.')
end);


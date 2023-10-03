local reloader = require("plenary.reload")

local function map()
    local ui = require("sticky.ui")
    vim.keymap.set("n", "<leader>sa", ui.toggle_quick_menu)
end
map()

vim.keymap.set('n', '<leader>srl', function()
 reloader.reload_module("sticky.ui")
 map()
 print('sticky reloaded.')
end);


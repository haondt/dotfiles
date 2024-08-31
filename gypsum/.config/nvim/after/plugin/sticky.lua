local reloader = require("plenary.reload")

local function map()
    local ui = require("sticky.ui")
    local mark = require("sticky.mark")
    vim.keymap.set("n", "<leader>sa", ui.toggle_quick_menu, { desc = 'show [a]ll [s]ticky registers'})

    vim.keymap.set("n", "<leader>s1", function() mark.stick_current(1) end, { desc = '[s]tick current to register [1]' })
    vim.keymap.set("n", "<leader>s2", function() mark.stick_current(2) end, { desc = '[s]tick current to register [2]' })
    vim.keymap.set("n", "<leader>s3", function() mark.stick_current(3) end, { desc = '[s]tick current to register [3]' })
    vim.keymap.set("n", "<leader>s4", function() mark.stick_current(4) end, { desc = '[s]tick current to register [4]' })
    vim.keymap.set("n", "<leader>s5", function() mark.stick_current(5) end, { desc = '[s]tick current to register [5]' })
    vim.keymap.set("n", "<leader>s6", function() mark.stick_current(6) end, { desc = '[s]tick current to register [6]' })
    vim.keymap.set("n", "<leader>s7", function() mark.stick_current(7) end, { desc = '[s]tick current to register [7]' })
    vim.keymap.set("n", "<leader>s8", function() mark.stick_current(8) end, { desc = '[s]tick current to register [8]' })

    vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end, { desc = 'go to sticky register 1' })
    vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end, { desc = 'go to sticky register 2' })
    vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end, { desc = 'go to sticky register 3' })
    vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end, { desc = 'go to sticky register 4' })
    vim.keymap.set("n", "<leader>5", function() ui.nav_file(5) end, { desc = 'go to sticky register 5' })
    vim.keymap.set("n", "<leader>6", function() ui.nav_file(6) end, { desc = 'go to sticky register 6' })
    vim.keymap.set("n", "<leader>7", function() ui.nav_file(7) end, { desc = 'go to sticky register 7' })
    vim.keymap.set("n", "<leader>8", function() ui.nav_file(8) end, { desc = 'go to sticky register 8' })
end
map()

vim.keymap.set('n', '<leader>rls', function()
 reloader.reload_module("sticky")
 map()
 print('sticky reloaded.')
end, { desc = '[r]e[l]oad [s]ticky'});


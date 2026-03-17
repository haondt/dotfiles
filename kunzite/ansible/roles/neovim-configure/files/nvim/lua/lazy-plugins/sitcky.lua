return {
    dir = vim.fn.stdpath("config") .. "/lua/sticky",
    name = "sticky",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require('sticky') -- runs M.setup() since it's called at module level

        local reloader = require("plenary.reload")

        local function map()
            local ui = require("sticky.ui")
            local mark = require("sticky.mark")
            vim.keymap.set("n", "<leader>sa", ui.toggle_quick_menu, { desc = 'show [a]ll [s]ticky registers' })

            for i = 1, 8 do
                vim.keymap.set("n", "<leader>s" .. i, function() mark.stick_current(i) end,
                    { desc = '[s]tick current to register [' .. i .. ']' })
                vim.keymap.set("n", "<leader>" .. i, function() ui.nav_file(i) end,
                    { desc = 'go to sticky register ' .. i })
            end
        end
        map()

        vim.keymap.set('n', '<leader>rls', function()
            reloader.reload_module("sticky")
            map()
            print('sticky reloaded.')
        end, { desc = '[r]e[l]oad [s]ticky' })
    end
}

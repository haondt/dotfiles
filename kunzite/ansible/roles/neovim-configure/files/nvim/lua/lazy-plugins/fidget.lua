return {
    "j-hui/fidget.nvim",
    dependencies = {
        { "nvim-telescope/telescope.nvim" },
    },
    config = function()
        require('fidget').setup({
            notification = {
                -- override_vim_notify = true,
                window = {
                    -- border = "single",
                    winblend = 0,
                    normal_hl = "Folded",
                }
            },
            progress = {
                display = {
                    done_style = "Special",
                    group_style = "LineNr"
                }
            }
        })
        require("telescope").load_extension("fidget")
        vim.keymap.set("n", "<leader>fn", function()
            require("telescope").extensions.fidget.fidget()
        end, { desc = "[f]idget [n]otifications" })
    end
}

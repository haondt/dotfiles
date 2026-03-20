return {
    "j-hui/fidget.nvim",
    dependencies = {
        { "nvim-telescope/telescope.nvim" },
    },
    config = function()
        require('fidget').setup({
            notification = {
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
        -- TODO: set up this binding
        -- require("telescope").extensions.fidget.fidget()
    end
}

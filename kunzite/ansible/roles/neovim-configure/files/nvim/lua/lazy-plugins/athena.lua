return {
    "haondt/athena.nvim",
    version = "7525ea36dd4c27ee26f2afc311ab84e152e9772a",
    -- dir = "~/projects/athena.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    opts = {
    },
    keys = {
        {
            "<leader>ah",
            "<CMD>AthenaHistory<CR>",
            desc = "[a]thena [h]istory"
        },
        {
            "<leader>at",
            "<CMD>AthenaToggle<CR>",
            desc = "[a]thena [t]oggle"
        },
        {
            "<leader>ar",
            "<CMD>AthenaResponse<CR>",
            desc = "[a]thena [r]esponse"
        },
        {
            "<leader>ad",
            "<CMD>Athena<CR>",
            desc = "[a]thena [d]efault"
        },
    }
}

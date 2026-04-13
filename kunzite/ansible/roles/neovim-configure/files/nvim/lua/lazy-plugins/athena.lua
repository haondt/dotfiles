return {
    "haondt/athena.nvim",
    version = "31cb7c2b0672f0f6a089cae108377b2bf80868d9",
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

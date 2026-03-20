return {
    "haondt/nuget.nvim",
    --dir = "~/projects/nuget.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "j-hui/fidget.nvim",
    },
    opts = {
        keys = {
            install     = { "n", "<leader>ni" },
            remove      = { "n", "<leader>nr" },
            clear_cache = { "n", "<leader>nc" },
        },
        dotnet = {
            method = "parse"
        }
    },
    ft = { "cs", "csproj", "solution", "razor" },
    config = function(_, opts)
        require("nuget").setup(opts)
        vim.keymap.set("n", "<leader>na", function()
            require("nuget.install")({ dotnet = { prerelease = true } })
        end, { desc = "Install a NuGet prerelease package" })
    end,
}

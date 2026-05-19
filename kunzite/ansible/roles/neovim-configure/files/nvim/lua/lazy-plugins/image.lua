return {
    "3rd/image.nvim",
    event = "VeryLazy",
    dependencies = {
        { "nvim-treesitter/nvim-treesitter" }
    },
    opts = {
        backend = "sixel",
        processor = "magick_rock",
        integrations = {
            markdown = {
                only_render_image_at_cursor = true,
            },
        },
    },
    rocks = {
        hererocks = true
    }
}

return {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = { "nvim-lua/plenary.nvim", 'nvim-telescope/telescope.nvim', "j-hui/fidget.nvim" },
    opts = {
        test_runner = {
            icons = {
                passed       = "o",
                skipped      = "~",
                failed       = "x",
                success      = "o",
                reload       = "?",
                test         = "",
                sln          = "",
                project      = "",
                dir          = "",
                package      = "",
                class        = "",
                build_failed = "!",
            },
            hide_legend = true,
            mappings = {
                run_test_from_buffer = { lhs = "<leader>rt", desc = "[r]un test" },
                run = { lhs = "r", desc = "[r]un test" },
                expand = { lhs = "<Tab>", desc = "toggle node" },
                go_to_file = { lhs = "<CR>", desc = "open file" },
                peek_stacktrace = { lhs = "e", desc = "[e]rrors" },
                peek_stack_trace_from_buffer = { lhs = "<leader>re", desc = "test [r]un [e]rrors" }
            }
        },
        notifications = {
            handler = function(start_event)
                local handle = require("fidget.progress.handle").create({
                    title = "easy-dotnet",
                    message = start_event.job.name, -- e.g. "building...", "restoring..."
                    lsp_client = { name = "easy-dotnet" },
                })

                return function(finished_event)
                    handle:report({
                        message = (finished_event.success and "" or "ERR ") .. finished_event.result.msg,
                    })
                    handle:finish()
                end
            end
        },
        lsp = { enabled = false }
    },
    keys = {
        { '<leader>pt', '<cmd>Dotnet testrunner<cr>', desc = '[p]roject [t]ests' },
    },
    ft = { "cs", "razor" }
}

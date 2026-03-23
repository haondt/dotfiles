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
        lsp = {
            config = {
                settings = {
                    ["csharp|code_lens"] = {
                        dotnet_enable_references_code_lens = false,
                        dotnet_enable_tests_code_lens = false,
                    },
                    ["csharp|background_analysis"] = {
                        ["background_analysis.dotnet_analyzer_diagnostics_scope"] = "fullSolution",
                        ["background_analysis.dotnet_compiler_diagnostics_scope"] = "fullSolution",
                    }
                }
            }
        }
    },
    keys = {
        { '<leader>pt', '<cmd>Dotnet testrunner<cr>', desc = '[p]roject [t]ests' },
    },
    ft = { "cs", "razor" },
    config = function(_, opts)
        -- disable easy_dotnet diagnostics in favor of roslyn
        local orig_diag = vim.lsp.handlers["textDocument/diagnostic"]
        vim.lsp.handlers["textDocument/diagnostic"] = function(err, result, ctx, config)
            local client = vim.lsp.get_client_by_id(ctx.client_id)
            if client and client.name == "easy_dotnet" then return end
            orig_diag(err, result, ctx, config)
        end
        require('easy-dotnet').setup(opts)

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client and client.name == "easy_dotnet" then
                    client.server_capabilities.hoverProvider = nil
                    client.server_capabilities.codeLensProvider = nil
                    client.server_capabilities.completionProvider = nil
                    client.server_capabilities.signatureHelpProvider = nil
                    client.server_capabilities.definitionProvider = nil
                    client.server_capabilities.referencesProvider = nil
                    client.server_capabilities.inlayHintProvider = nil
                    client.server_capabilities.diagnosticProvider = nil
                end
            end,
        })
    end
}

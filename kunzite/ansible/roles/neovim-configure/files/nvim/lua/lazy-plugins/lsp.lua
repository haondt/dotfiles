return {
    {
        "neovim/nvim-lspconfig"
    },
    {
        "mason-org/mason.nvim",
        opts = {
            registries = {
                "github:mason-org/mason-registry",
                "github:Crashdummyy/mason-registry",
            }
        }
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = {
                "roslyn", -- auto-installed via Crashdummyy registry
            },
        },
    },
    {
        "seblyng/roslyn.nvim",
        dependencies = { "j-hui/fidget.nvim" },
        config = function()
            require('roslyn').setup({

            })
            if true then
                return
            end

            vim.lsp.config['roslyn'] = {
                settings = {
                    ["csharp|inlay_hints"] = {
                        csharp_enable_inlay_hints_for_implicit_object_creation = true,
                        csharp_enable_inlay_hints_for_implicit_variable_types = true,
                        csharp_enable_inlay_hints_for_lambda_parameter_types = true
                    },
                    ["csharp|code_lens"] = {
                        dotnet_enable_references_code_lens = true,
                    },
                    ["csharp|formatting"] = {
                        dotnet_organize_imports_on_format = true,
                    },
                    ["csharp|background_analysis"] = {
                        ["background_analysis.dotnet_analyzer_diagnostics_scope"] = "fullSolution",
                        ["background_analysis.dotnet_compiler_diagnostics_scope"] = "fullSolution",
                    }
                }
            }

            local handles = {}

            -- dotnet restore output to fidget
            vim.api.nvim_create_autocmd("User", {
                pattern = "RoslynRestoreProgress",
                callback = function(ev)
                    local token = ev.data.params[1]
                    local handle = handles[token]
                    if handle then
                        handle:report({
                            title = ev.data.params[2].state,
                            message = ev.data.params[2].message,
                        })
                    else
                        handles[token] = require("fidget.progress").handle.create({
                            title = ev.data.params[2].state,
                            message = ev.data.params[2].message,
                            lsp_client = {
                                name = "roslyn",
                            },
                        })
                    end
                end,
            })
            vim.api.nvim_create_autocmd("User", {
                pattern = "RoslynRestoreResult",
                callback = function(ev)
                    local handle = handles[ev.data.token]
                    handles[ev.data.token] = nil

                    if handle then
                        handle.message = ev.data.err and ev.data.err.message or "Restore completed"
                        handle:finish()
                    end
                end,
            })

            -- Diagnostic refresh
            vim.api.nvim_create_autocmd({ "InsertLeave" }, {
                pattern = "*",
                callback = function()
                    local clients = vim.lsp.get_clients({ name = "roslyn" })
                    if not clients or #clients == 0 then
                        return
                    end

                    local client = clients[1]
                    local buffers = vim.lsp.get_buffers_by_client_id(client.id)
                    for _, buf in ipairs(buffers) do
                        local params = { textDocument = vim.lsp.util.make_text_document_params(buf) }
                        client:request("textDocument/diagnostic", params, nil, buf)
                    end
                end,
            })

            -- autoinsert /// <summary>...
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    local bufnr = args.buf

                    if client and (client.name == "roslyn" or client.name == "roslyn_ls") then
                        vim.api.nvim_create_autocmd("InsertCharPre", {
                            desc = "Roslyn: Trigger an auto insert on '/'.",
                            buffer = bufnr,
                            callback = function()
                                local char = vim.v.char

                                if char ~= "/" then
                                    return
                                end

                                local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))
                                row, col = row - 1, col + 1
                                local uri = vim.uri_from_bufnr(bufnr)

                                local params = {
                                    _vs_textDocument = { uri = uri },
                                    _vs_position = { line = row, character = col },
                                    _vs_ch = char,
                                    _vs_options = {
                                        tabSize = vim.bo[bufnr].tabstop,
                                        insertSpaces = vim.bo[bufnr].expandtab,
                                    },
                                }

                                -- NOTE: We should send textDocument/_vs_onAutoInsert request only after
                                -- buffer has changed.
                                vim.defer_fn(function()
                                    client:request(
                                    ---@diagnostic disable-next-line: param-type-mismatch
                                        "textDocument/_vs_onAutoInsert",
                                        params,
                                        function(err, result, _)
                                            if err or not result then
                                                return
                                            end

                                            vim.snippet.expand(result._vs_textEdit.newText)
                                        end,
                                        bufnr
                                    )
                                end, 1)
                            end,
                        })
                    end
                end,
            })
        end
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            'williamboman/mason.nvim',
            'neovim/nvim-lspconfig',
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local bufnr = args.buf
                    local map = function(keys, func, desc)
                        vim.keymap.set('n', keys, func, {
                            buffer = bufnr,
                            remap = false,
                            desc = desc
                        })
                    end
                    map('<leader>c=', vim.lsp.buf.format, '[c]ode format (with lsp)')
                    map('<leader>cr', vim.lsp.buf.rename, '[c]ode [r]ename')
                    map('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ctions')
                    map('<leader>ch', vim.lsp.buf.hover, '[c]ode hover')
                    map('<leader>cs', vim.lsp.buf.signature_help, '[c]ode [s]ignature help')

                    -- Format on save
                    local format_on_save_types = { 'typescript', 'razor', 'cs', 'html', 'lua' }
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        buffer = bufnr,
                        callback = function()
                            local ft = vim.bo[bufnr].filetype
                            if vim.tbl_contains(format_on_save_types, ft) then
                                vim.lsp.buf.format({ bufnr = bufnr })
                            end
                        end,
                    })
                end
            })

            require('mason-lspconfig').setup({
                ensure_installed = {
                    'lua_ls', 'rust_analyzer', 'jedi_language_server', 'pyright',
                    'ansiblels', 'cssls', 'dockerls',
                    'docker_compose_language_service', 'eslint', 'html',
                    'jsonls', 'ts_ls', 'marksman', 'taplo', 'yamlls'
                },
            })

            vim.lsp.config['lua_ls'] = {
                settings = {
                    Lua = {
                        diagnostics = { globals = { 'vim' } }
                    }
                }
            }
            vim.lsp.config['pyright'] = {
                settings = {
                    python = {
                        analysis = {
                            diagnosticMode = "workspace",
                            exclude = "**/venv/**/*"
                        }
                    }
                }
            }
        end
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
        },
        config = function()
            local cmp = require('cmp')
            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            cmp.setup({
                sources = {
                    { name = 'nvim_lsp' }
                },
                window = {
                    completion = {
                        border = 'single',
                        winhighlight = 'Pmenu:NormalFloat'
                    },
                    documentation = {
                        border = 'single',
                    }
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4)
                })
            })
        end
    }
}

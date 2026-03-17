return {
    {
        "neovim/nvim-lspconfig"
    },
    {
        "mason-org/mason.nvim",
        opts = {}
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
                    local format_on_save_types = { 'typescript', 'python', 'csharp', 'html', 'lua' }
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
                    'omnisharp', 'ansiblels', 'cssls', 'dockerls',
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
            vim.lsp.config['omnisharp'] = {}
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

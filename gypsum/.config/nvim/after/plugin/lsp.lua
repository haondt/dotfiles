local lsp = require('lsp-zero')

lsp.on_attach(function(client, bufnr)
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
end)

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

local servers = {
    lsp.default_setup,
    omnisharp = {},
    lua_ls = {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'vim' }
                }
            }
        }
    },
    pyright = {
        settings = {
            python = {
                analysis = {
                    diagnosticMode = "workspace"
                }
            }
        }
    }
}

require('mason').setup({})

require('mason-lspconfig').setup({
    ensure_installed = {
        'lua_ls',
        'rust_analyzer',
        'jedi_language_server',
        'pyright',
        'omnisharp',
        'ansiblels',
        'cssls',
        'dockerls',
        'docker_compose_language_service',
        'eslint',
        'html',
        'jsonls',
        'tsserver',
        'marksman',
        'taplo',
        'yamlls'
    },
    handlers = {
        function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
        end
    }
})


local cmp = require('cmp')
local cmp_action = lsp.cmp_action()
local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
--  sources = {
--      { name = 'nvim_lsp' }
--  }, 
    window = {
        completion = {
           border = 'single',
           winhighlight = 'Pmenu:NormalFloat'
        },
        documentation = {
           border = 'single',
           --winhighlight = 'NormalFloat:FloatBorder'
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

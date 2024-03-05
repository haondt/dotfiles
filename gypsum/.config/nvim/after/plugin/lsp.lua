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

require('mason').setup({})
local lspconfig = require('lspconfig')
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
        lsp.default_setup,
        omnisharp = function()
            lspconfig.omnisharp.setup({})
        end,
        pyright = function()
            lspconfig.pyright.setup({
                settings = {
                    python = {
                        analysis = {
                            diagnosticMode = "workspace"
                        }
                    }
                }
            })
        end
    }
})


local cmp = require('cmp')
local cmp_action = lsp.cmp_action()
local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
--	sources = {
--		{ name = 'nvim_lsp' }
--	}, 
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
		['<C-Space>'] = cmp.mapping.complete()
	})
})

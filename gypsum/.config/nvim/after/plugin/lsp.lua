local lsp = require('lsp-zero')

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }
	--lsp.default_keymaps({buffer = bufnr})

    vim.keymap.set('n', '<leader>=', vim.lsp.buf.format, opts)
    --vim.lsp.buf.hover()
    --vim.lsp.buf.signature_help()
    --vim.lsp.buf.rename()
    --vim.lsp.buf.code_action()
    --vim.diagnostic.open_float()
    --vim.diagnostic.goto_[prev|next]()
    

	--vim.keymap.set('n', 'gh', function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set('n', '<leader>vd', function() end, opts)
	--vim.keymap.set('n', '[d', function() vim.lsp.buf.goto_next() end, opts)
	--vim.keymap.set('n', ']d', function() vim.lsp.buf.goto_prev() end, opts)
	--vim.keymap.set('n', '<leader>vca', function() vim.lsp.buf.code_action() end, opts)
	-- vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, opts)
	-- vim.keymap.set('n', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
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
	mapping = cmp.mapping.preset.insert({
		['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
		['<C-n>'] = cmp.mapping.select_next_item(cpm_select),
		['<Tab>'] = cmp.mapping.confirm({ select = true }),
		['<C-Space>'] = cmp.mapping.complete()
	})
})

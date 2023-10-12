local lsp = require('lsp-zero')

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }
	lsp.default_keymaps({buffer = bufnr})
	vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set('n', 'gh', function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set('n', '<leader>vd', function() vim.lsp.buf.open_float() end, opts)
	vim.keymap.set('n', '[d', function() vim.lsp.buf.goto_next() end, opts)
	vim.keymap.set('n', ']d', function() vim.lsp.buf.goto_prev() end, opts)
	vim.keymap.set('n', '<leader>vca', function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, opts)
	vim.keymap.set('n', '<leader>vrn', function() vim.lsp.buf.rename() end, opts)
	-- vim.keymap.set('n', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
end)

require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {
		'lua_ls',
		'rust_analyzer',
		'jedi_language_server',
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
		lsp.default_setup
	}
})

local lspconfig = require('lspconfig')
lspconfig.omnisharp.setup({})

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

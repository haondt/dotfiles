-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup({
                mappings = { basic = false, extra = false },
            })
        end
    }

    use {
        'folke/which-key.nvim',
        config = function()
            require('which-key').setup({
                registers = false,
                spelling = { enabled = false },
                icons = {
                    breadcrumb = '',
                    separator = '',
                    group = ''
                },
                window = {
                    border = 'single',
                    winblend = 0
                }
            })

            require('which-key').register({
                ['<leader>g'] = { name = '[g]it', _ = 'which_key_ignore' },
                ['<leader>p'] = { name = '[p]roject actions', _ = 'which_key_ignore' },
                ['<leader>o'] = { name = '[o]pen action on buffer', _ = 'which_key_ignore' },
                ['<leader>c'] = { name = '[c]ode actions', _ = 'which_key_ignore' },
                ['<leader>d'] = { name = 'start [d]iff modes', _ = 'which_key_ignore' },
                ['<leader>t'] = { name = '[t]ext tools', _ = 'which_key_ignore' },
                ['<leader>ta'] = { name = '[t]ext [a]lign', _ = 'which_key_ignore' },
                ['d'] = { name = '[d]iff mode actions', _ = 'which_key_ignore' }
            })
        end
    }

    use {
        'folke/todo-comments.nvim',
        config = function ()
            require('todo-comments').setup({
                signs = false
            })

        end,
        requires = { "nvim-lua/plenary.nvim" }
    }

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.3',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate'})
    use('nvim-treesitter/playground')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')
    use('nvim-treesitter/nvim-treesitter-context')
    use{
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    use {
        'nvim-tree/nvim-tree.lua'
    }
    use{
        'haondt/nvim-tree.lua-float-preview'
    }

    use {
        "eoh-bse/minintro.nvim",
        config = function() require("minintro").setup({ color = "#cc6666" }) end
    }

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            --- Uncomment these if you want to manage LSP servers from neovim
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- LSP Support
            {'neovim/nvim-lspconfig'},
            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
        }
    }

    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }

    use {'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async'}

    use {
        'echasnovski/mini.nvim',
        config = function ()
            require('mini.align').setup({
                mappings = {
                    start = '',
                    start_with_preview = '<leader>ta',
                }
            })
        end
    }
end)
